﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область СохранениеДвижений

// Добавляет в дополнительные свойства документа служебное свойство,
// в котором сохраняются дата начала и окончания периода,
// за который необходимо сохранить движения из ИБ в записываемый набор записей регистра.
//
Процедура ИнициализироватьСохранениеДвиженийДокументаЗаПериод(ДополнительныеСвойстваДокумента,
			НачалоПериода = Неопределено, КонецПериода = Неопределено) Экспорт
	
	ДополнительныеСвойстваДокумента.Вставить("ДополнитьДвижениямиИзИБЗаПериод", Новый Структура);
	
	ДополнительныеСвойстваДокумента.ДополнитьДвижениямиИзИБЗаПериод.Вставить(
		"НачалоПериода",
		?(ЗначениеЗаполнено(НачалоПериода), НачалоПериода, Дата(1,1,1)));
	
	ДополнительныеСвойстваДокумента.ДополнитьДвижениямиИзИБЗаПериод.Вставить(
		"КонецПериода", 
		?(ЗначениеЗаполнено(КонецПериода),  КонецПериода,  ДобавитьМесяц(КонецМесяца(ТекущаяДатаСеанса()), 12*100)));
	
КонецПроцедуры

Процедура ИнициализироватьСохранениеДвиженийНабораЗаписейЗаПериод(Движение, ДополнительныеСвойстваДокумента) Экспорт
	
	Если ДополнительныеСвойстваДокумента.Свойство("ДополнитьДвижениямиИзИБЗаПериод") Тогда
		
		Движение.ДополнительныеСвойства.Вставить(
			"ДополнитьДвижениямиИзИБЗаПериод",
			ДополнительныеСвойстваДокумента.ДополнитьДвижениямиИзИБЗаПериод);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления УТ 11.4.1
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ПолноеИмяРегистра = "РегистрНакопления.СебестоимостьТоваров";
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр(
		"ДатаПереходаНаПартионныйУчетВерсии22",
		УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ДатаПереходаНаПартионныйУчетВерсии22());
	Запрос.УстановитьПараметр(
		"ПартионныйУчетВерсии22",
		УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВерсии22(НачалоМесяца(ТекущаяДатаСеанса())));
	Запрос.УстановитьПараметр(
		"ФормироватьВидыЗапасовПоСделкам",
		ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоСделкам"));
	Запрос.УстановитьПараметр(
		"ФормироватьВидыЗапасовПоПодразделениямМенеджерам",
		ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам"));
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Движения.Ссылка КАК Ссылка
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		Движения.Регистратор КАК Ссылка
	|	ИЗ
	|		РегистрНакопления.СебестоимостьТоваров КАК Движения
	|	ГДЕ
	|		Движения.Организация = ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|		И Движения.АналитикаУчетаПоПартнерам <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПоПартнерам.ПустаяСсылка)
	|		И Движения.КорВидДеятельностиНДС <> ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
	|	
	|	
	|	//%ТекстЗапросаВидыЗапасов
	|
	|	) КАК Движения
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	// Заполним аналитику фин. учета по разделу "ТоварыВПути"
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Движения.Регистратор
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК Движения
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК Реализации
	|	ПО &ПартионныйУчетВерсии22
	|		И Движения.Период >= &ДатаПереходаНаПартионныйУчетВерсии22
	|		И Движения.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыВПути)
	|		И Движения.Регистратор = Реализации.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|	ПО СтруктураПредприятия.Ссылка = Реализации.Подразделение
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СделкиСКлиентами КАК Сделки
	|	ПО Сделки.Ссылка = Реализации.Сделка
	|
	|ГДЕ
	|	&ПартионныйУчетВерсии22
	|	И Движения.Период >= &ДатаПереходаНаПартионныйУчетВерсии22
	|	И Движения.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыВПути)
	|	И (&ФормироватьВидыЗапасовПоСделкам
	|			И ЕСТЬNULL(Сделки.ОбособленныйУчетТоваровПоСделке, ЛОЖЬ)
	|		ИЛИ &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|			И ЕСТЬNULL(СтруктураПредприятия.ВариантОбособленногоУчетаТоваров, ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПустаяСсылка))
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения)
	|		ИЛИ &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|			И ЕСТЬNULL(СтруктураПредприятия.ВариантОбособленногоУчетаТоваров, ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПустаяСсылка))
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоПодразделению))
	|	И Движения.АналитикаФинансовогоУчета = НЕОПРЕДЕЛЕНО
	|";
	
	Если ПолучитьФункциональнуюОпцию("УчитыватьСебестоимостьТоваровПоВидамЗапасов") Тогда
		
		ТекстЗапросаНазначения = "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|";
		
		ТекстЗапросаНазначения = ТекстЗапросаНазначения + "
		|	ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		Движения.Регистратор КАК Ссылка
		|	ИЗ
		|		РегистрНакопления.СебестоимостьТоваров КАК Движения
		|	ГДЕ
		|		Движения.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Услуга)
		|		ИЛИ Движения.КорВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Услуга)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		Движения.Регистратор КАК Ссылка
		|	ИЗ
		|		РегистрНакопления.СебестоимостьТоваров КАК Движения
		|	ГДЕ
		|		Движения.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
		|		И (ТИПЗНАЧЕНИЯ(Движения.АналитикаУчетаНоменклатуры.Склад) = ТИП(Справочник.Партнеры)
		|			ИЛИ ТИПЗНАЧЕНИЯ(Движения.АналитикаУчетаНоменклатуры.Склад) = ТИП(Справочник.Организации))
		|		И Движения.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах)
		|";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "//%ТекстЗапросаВидыЗапасов", ТекстЗапросаНазначения);
		
	КонецЕсли;
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

// Обработчик обновления УТ 11.4.1:
// - очищаются виды запасов для товаров выкупленных у комитента;
// - очищается кор. вид деятельности и аналитика учета по партнерам для управленческой организации.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.СебестоимостьТоваров";
	МетаданныеРегистра = Метаданные.РегистрыНакопления.СебестоимостьТоваров;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр(
		"ИспользоватьВидыЗапасов",
		ПолучитьФункциональнуюОпцию("УчитыватьСебестоимостьТоваровПоВидамЗапасов"));
	Запрос.УстановитьПараметр(
		"ДатаПереходаНаПартионныйУчетВерсии22",
		УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ДатаПереходаНаПартионныйУчетВерсии22());
	Запрос.УстановитьПараметр(
		"ПартионныйУчетВерсии22",
		УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВерсии22(НачалоМесяца(ТекущаяДатаСеанса())));
	Запрос.УстановитьПараметр(
		"ФормироватьВидыЗапасовПоСделкам",
		ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоСделкам"));
	Запрос.УстановитьПараметр(
		"ФормироватьВидыЗапасовПоПодразделениямМенеджерам",
		ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам"));
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Движения.Период,
	|	Движения.Регистратор,
	|	Движения.ВидДвижения,
	|
	|	Движения.АналитикаУчетаНоменклатуры,
	
	|	ВЫБОР
	|		КОГДА ИСТИНА
	|			ТОГДА Движения.РазделУчета
	|	КОНЕЦ КАК РазделУчета,
	
	|	ВЫБОР КОГДА &ИспользоватьВидыЗапасов
	|		И (((Ключи.Склад ССЫЛКА Справочник.Партнеры ИЛИ Ключи.Склад ССЫЛКА Справочник.Организации)
	|				И Движения.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах)
	|				И Движения.ВидЗапасов <> ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка))
	|			ИЛИ Движения.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Услуга))
	|		ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|		ИНАЧЕ Движения.ВидЗапасов
	|	КОНЕЦ КАК ВидЗапасов,
	|	Движения.Организация,
	|	Движения.Партия,
	|	Движения.АналитикаУчетаПартий,
	|	ВЫБОР
	|		КОГДА НЕ Движения.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыВПути)
	|			ТОГДА Движения.АналитикаФинансовогоУчета
	|		КОГДА &ФормироватьВидыЗапасовПоСделкам
	|			И ЕСТЬNULL(Сделки.ОбособленныйУчетТоваровПоСделке, ЛОЖЬ)
	|			ТОГДА Реализации.Сделка
	|		КОГДА &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|			И ЕСТЬNULL(СтруктураПредприятия.ВариантОбособленногоУчетаТоваров, ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПустаяСсылка))
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения)
	|			ТОГДА Реализации.Менеджер
	|		КОГДА &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|			И ЕСТЬNULL(СтруктураПредприятия.ВариантОбособленногоУчетаТоваров, ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПустаяСсылка))
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоПодразделению)
	|			ТОГДА Реализации.Подразделение
	|		ИНАЧЕ Движения.АналитикаФинансовогоУчета
	|	КОНЕЦ КАК АналитикаФинансовогоУчета,
	|	Движения.ВидДеятельностиНДС,
	|
	|	Движения.Количество,
	|	Движения.Стоимость,
	|	Движения.СтоимостьБезНДС,
	|	Движения.СтоимостьЗабалансовая,
	|	Движения.ДопРасходы,
	|	Движения.ДопРасходыБезНДС,
	|	Движения.Трудозатраты,
	|	Движения.ПостатейныеПостоянныеСНДС,
	|	Движения.ПостатейныеПостоянныеБезНДС,
	|	Движения.СтоимостьРегл,
	|	Движения.СтоимостьЗабалансоваяРегл,
	|	Движения.ДопРасходыРегл,
	|	Движения.ТрудозатратыРегл,
	|	Движения.ПостатейныеПостоянныеРегл,
	|	Движения.ПостояннаяРазница,
	|	Движения.ВременнаяРазница,
	|
	|	ВЫБОР
	|		КОГДА Движения.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыпускПродукцииНаСклад),
	|										ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыпускПродукцииВПодразделение))
	|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыпускПродукции)
	|		ИНАЧЕ Движения.ХозяйственнаяОперация
	|	КОНЕЦ КАК ХозяйственнаяОперация,
	|
	|	Движения.КорАналитикаУчетаНоменклатуры,

	|	ВЫБОР
	|		КОГДА ИСТИНА
	|			ТОГДА Движения.КорРазделУчета
	|	КОНЕЦ КАК КорРазделУчета,
	
	|	ВЫБОР КОГДА &ИспользоватьВидыЗапасов 
	|			И (((КорКлючи.Склад ССЫЛКА Справочник.Партнеры ИЛИ КорКлючи.Склад ССЫЛКА Справочник.Организации)
	|					И Движения.КорРазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах)
	|					И Движения.КорВидЗапасов <> ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка))
	|				ИЛИ Движения.КорВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Услуга))
	|		ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|		ИНАЧЕ Движения.КорВидЗапасов
	|	КОНЕЦ КАК КорВидЗапасов,
	|	Движения.КорОрганизация,
	|	Движения.КорСтоимость,
	|	ВЫБОР КОГДА Движения.Организация = ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|		ТОГДА ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПоПартнерам.ПустаяСсылка)
	|		ИНАЧЕ Движения.АналитикаУчетаПоПартнерам
	|	КОНЕЦ КАК АналитикаУчетаПоПартнерам,
	|	Движения.ЗаказКлиента,
	|	Движения.Подразделение,
	|	Движения.АналитикаРасходов,
	|	Движения.СтатьяРасходовСписания,
	|	Движения.СтатьяДоходов,
	|	Движения.АналитикаДоходов,
	|	Движения.ПериодПродажи,
	|	Движения.СтатьяАктивовПассивов,
	|	Движения.АналитикаАктивовПассивов,
	|	Движения.ДокументДвижения,
	|	Движения.ИдентификаторСтроки,
	|	Движения.ГруппаПродукции,
	|	ВЫБОР
	|		КОГДА ИСТИНА
	|			ТОГДА Движения.РасчетПартий
	|	КОНЕЦ КАК РасчетПартий,
	|	Движения.РасчетСебестоимости,
	|	Движения.КорПартия,
	|	Движения.КорАналитикаУчетаПартий,
	|	Движения.КорАналитикаФинансовогоУчета,
	|	ВЫБОР КОГДА Движения.Организация = ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
	|		ИНАЧЕ Движения.КорВидДеятельностиНДС
	|	КОНЕЦ КАК КорВидДеятельностиНДС,
	|	Движения.НДСРегл,
	|			Движения.СтатьяКалькуляции
	|	КАК СтатьяКалькуляции,
	|	Движения.ТипЗаписи,
	|	Движения.ДокументИсточник,
	|	Движения.АналитикаУчетаПартийПроизводства
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК Движения
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Ключи
	|	ПО Ключи.Ссылка = Движения.АналитикаУчетаНоменклатуры
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК КорКлючи
	|	ПО КорКлючи.Ссылка = Движения.КорАналитикаУчетаНоменклатуры
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК Реализации
	|	ПО &ПартионныйУчетВерсии22
	|		И Движения.Период >= &ДатаПереходаНаПартионныйУчетВерсии22
	|		И Движения.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыВПути)
	|		И Движения.Регистратор = Реализации.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|	ПО СтруктураПредприятия.Ссылка = Реализации.Подразделение
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СделкиСКлиентами КАК Сделки
	|	ПО Сделки.Ссылка = Реализации.Сделка
	|
	|ГДЕ
	|	Движения.Регистратор = &Регистратор
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьРегистраторыРегистраДляОбработки(Параметры.Очередь, Неопределено, ПолноеИмяРегистра);
	
	Пока Выборка.Следующий() Цикл
		
		Регистратор = Выборка.Регистратор;
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;

			Блокировка.Заблокировать();
			
			Запрос.УстановитьПараметр("Регистратор", Регистратор);
			
			Результат = Запрос.Выполнить();
			
			Если Результат.Пустой() Тогда
				
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Регистратор, ДополнительныеПараметры);
				
			Иначе
				
				Набор = РегистрыНакопления.СебестоимостьТоваров.СоздатьНаборЗаписей();
				Набор.Отбор.Регистратор.Установить(Регистратор);
				Набор.Загрузить(Результат.Выгрузить());
				
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %Регистратор% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Регистратор%", Регистратор);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				Регистратор.Метаданные(),
				ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
