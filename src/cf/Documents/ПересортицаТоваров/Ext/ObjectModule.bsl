﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПересчетТоваров") Тогда
		СтруктураРезультат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Статус, Склад");
		Если СтруктураРезультат.Статус <> Перечисления.СтатусыПересчетовТоваров.Выполнено Тогда 
			ТекстСообщения = НСтр("ru='Документ ""%ДокументПересчет%"" находится в статусе ""%СтатусПересчета%"". Ввод документа ""%ДокументАкт%"" на основании разрешен только в статусе ""%СтатусВыполнено%"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументПересчет%", ДанныеЗаполнения);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументАкт%", Метаданные.Документы.ПересортицаТоваров.Синоним);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СтатусВыполнено%", Перечисления.СтатусыПересчетовТоваров.Выполнено);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СтатусПересчета%", СтруктураРезультат.Статус);
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураРезультат, "Склад"); 
		ПересчетТоваров = ДанныеЗаполнения;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОрдерНаОтражениеПересортицыТоваров") Тогда
		ЗаполнитьНаОснованииОрдераНаОтражениеПересортицы(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ПриходоватьТоварыПоСебестоимостиСписания Тогда
		Для Каждого СтрокаТаблицы Из Товары Цикл
			Если СтрокаТаблицы.Цена <> 0 Тогда
				СтрокаТаблицы.Цена = 0;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ЗаполнитьАналитикиУчетаНоменклатуры();
		ЗаполнитьВидыЗапасов(Отказ);
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ВидыЗапасов);
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;

	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
														   НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПересортицаТоваров));
	
	// ИнтеграцияЕГАИС
	ИнтеграцияЕГАИСУТ.ЗаполнитьПризнакиЕстьАлкогольнаяПродукция(ЭтотОбъект);
	// Конец ИнтеграцияЕГАИС
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив;

	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.СуффиксДопРеквизита = "Оприходование";
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ,ПараметрыПроверки);
		
	Если ПриходоватьТоварыПоСебестоимостиСписания Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Цена");
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяДоходов");
	КонецЕсли;
	
	Для Каждого СтрТабл Из Товары Цикл
		АдресОшибки = НСтр("ru='в строке %НомерСтроки% списка ""Товары""'");
		АдресОшибки =  СтрЗаменить(АдресОшибки, "%НомерСтроки%", СтрТабл.НомерСтроки);
		
		Если ЗначениеЗаполнено(СтрТабл.Номенклатура)
			И СтрТабл.Номенклатура = СтрТабл.НоменклатураОприходование
			И СтрТабл.Характеристика = СтрТабл.ХарактеристикаОприходование 
			И СтрТабл.Серия = СтрТабл.СерияОприходование
			И СтрТабл.Назначение = СтрТабл.НазначениеОприходование Тогда
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрТабл.НомерСтроки, "НомерСтроки");
			ТекстОшибки = НСтр("ru='Списываемый товар совпадает с приходуемым'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки + " " + АдресОшибки,ЭтотОбъект,Поле,,Отказ);
		КонецЕсли;
			
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерГТД");
	Если ПолучитьФункциональнуюОпцию("ЗапретитьПоступлениеТоваровБезНомеровГТД") Тогда
		ПроверитьЗаполнениеНомеровГТД(Отказ);
	КонецЕсли;
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПересортицаТоваров),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,, МассивНепроверяемыхРеквизитов, Отказ);
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,, МассивНепроверяемыхРеквизитов, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ПроверитьСтавкиНДС(Отказ);
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ПересортицаТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизацийКПередаче(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюИзлишковНедостач(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюОтчетовКомитента(ДополнительныеСвойства, Движения, Отказ);
	
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	
	ПартионныйУчетСервер.ОтразитьПартииТоваровОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияНоменклатураНоменклатура(ДополнительныеСвойства, Движения, Отказ);
	
	
	СформироватьСписокРегистровДляКонтроля();
	
	ЗапасыСервер.ПодготовитьЗаписьТоваровОрганизаций(ЭтотОбъект, РежимЗаписиДокумента.Проведение);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыЗаполненения = ПараметрыЗаполненияВидовЗапасов();
	ЗапасыСервер.СформироватьРезервыПоТоварамОрганизаций(ЭтотОбъект, Отказ, ПараметрыЗаполненения);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();
	
	ЗапасыСервер.ПодготовитьЗаписьТоваровОрганизаций(ЭтотОбъект, РежимЗаписиДокумента.ОтменаПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПараметрыЗаполненения = ПараметрыЗаполненияВидовЗапасов();
	ПараметрыЗаполненения.ДокументДелаетИПриходИРасход = Ложь;
	ЗапасыСервер.СформироватьРезервыПоТоварамОрганизаций(ЭтотОбъект, Отказ, ПараметрыЗаполненения);

	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ИнициализироватьДокумент();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьНаОснованииОрдераНаОтражениеПересортицы(ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТоварыОрдера.Номенклатура   КАК Номенклатура,
	|	ТоварыОрдера.Характеристика КАК Характеристика,
	|	ТоварыОрдера.Назначение     КАК Назначение,
	|	УпаковкиТоваров.Ссылка      КАК Упаковка,
	|	ТоварыОрдера.Серия          КАК Серия
	|ПОМЕСТИТЬ ТоварныеМестаОрдера
	|ИЗ
	|	Документ.ОрдерНаОтражениеПересортицыТоваров.Товары КАК ТоварыОрдера
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиТоваров
	|		ПО ТоварыОрдера.Номенклатура.НаборУпаковок = УпаковкиТоваров.Владелец
	|ГДЕ
	|	ТоварыОрдера.Ссылка = &ДокументОснование
	|	И НЕ УпаковкиТоваров.ПометкаУдаления
	|	И УпаковкиТоваров.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТоварыОрдера.Номенклатура,
	|	ТоварыОрдера.Характеристика,
	|	ТоварыОрдера.Назначение,
	|	УпаковкиТоваров.Ссылка,
	|	ТоварыОрдера.Серия
	|ИЗ
	|	Документ.ОрдерНаОтражениеПересортицыТоваров.Товары КАК ТоварыОрдера
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиТоваров
	|		ПО ТоварыОрдера.Номенклатура.НаборУпаковок = ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры)
	|			И ТоварыОрдера.Номенклатура = УпаковкиТоваров.Владелец
	|ГДЕ
	|	УпаковкиТоваров.Ссылка = &ДокументОснование
	|	И НЕ УпаковкиТоваров.ПометкаУдаления
	|	И УпаковкиТоваров.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 1
	|ВЫБРАТЬ
	|	ТоварныеМеста.Номенклатура                  КАК Номенклатура,
	|	ТоварныеМеста.Характеристика                КАК Характеристика,
	|	ТоварныеМеста.Назначение                    КАК Назначение,
	|	ТоварныеМеста.Упаковка                      КАК Упаковка,
	|	ТоварныеМеста.Серия                         КАК Серия,
	|	СУММА(ЕСТЬNULL(ТоварыОрдера.Количество, 0)) КАК Количество
	|ПОМЕСТИТЬ ВтТоварныеМестаОрдера
	|ИЗ
	|	ТоварныеМестаОрдера КАК ТоварныеМеста
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОрдерНаОтражениеПересортицыТоваров.Товары КАК ТоварыОрдера
	|		ПО ТоварыОрдера.Ссылка = &ДокументОснование
	|		И ТоварныеМеста.Номенклатура = ТоварыОрдера.Номенклатура
	|		И ТоварныеМеста.Характеристика = ТоварыОрдера.Характеристика
	|		И ТоварныеМеста.Назначение = ТоварыОрдера.Назначение
	|		И ТоварныеМеста.Упаковка = ТоварыОрдера.Упаковка
	|		И ТоварныеМеста.Серия = ТоварыОрдера.Серия
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварныеМеста.Номенклатура,
	|	ТоварныеМеста.Характеристика,
	|	ТоварныеМеста.Назначение,
	|	ТоварныеМеста.Упаковка,
	|	ТоварныеМеста.Серия
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 2
	|ВЫБРАТЬ
	|	ТоварыОрдера.Номенклатура   КАК Номенклатура,
	|	ТоварыОрдера.Характеристика КАК Характеристика,
	|	ТоварыОрдера.Назначение     КАК Назначение,
	|	ТоварыОрдера.Серия          КАК Серия,
	|	МИНИМУМ(ВЫБОР
	|		КОГДА ТоварыОрдера.Количество - ВЫРАЗИТЬ(ТоварыОрдера.Количество КАК ЧИСЛО(15, 0)) >= 0
	|			ТОГДА ВЫРАЗИТЬ(ТоварыОрдера.Количество КАК ЧИСЛО(15, 0))
	|		ИНАЧЕ
	|			ВЫРАЗИТЬ(ТоварыОрдера.Количество КАК ЧИСЛО(15, 0)) - 1
	|	КОНЕЦ)                      КАК Количество
	|ПОМЕСТИТЬ ТоварыОрдераВТоварныхМестах
	|ИЗ
	|	ВтТоварныеМестаОрдера КАК ТоварыОрдера
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыОрдера.Номенклатура,
	|	ТоварыОрдера.Характеристика,
	|	ТоварыОрдера.Назначение,
	|	ТоварыОрдера.Серия
	|
	|ИМЕЮЩИЕ
	|	МИНИМУМ(ВЫБОР
	|		КОГДА ТоварыОрдера.Количество - ВЫРАЗИТЬ(ТоварыОрдера.Количество КАК ЧИСЛО(15, 0)) >= 0
	|			ТОГДА ВЫРАЗИТЬ(ТоварыОрдера.Количество КАК ЧИСЛО(15, 0))
	|		ИНАЧЕ
	|			ВЫРАЗИТЬ(ТоварыОрдера.Количество КАК ЧИСЛО(15, 0)) - 1
	|	КОНЕЦ) > 0
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 3
	|ВЫБРАТЬ
	|	ТоварыОрдера.Номенклатура                КАК Номенклатура,
	|	ТоварыОрдера.Характеристика              КАК Характеристика,
	|	ТоварыОрдера.Назначение                  КАК Назначение,
	|	ВЫБОР
	|		КОГДА ТоварыОрдера.СтатусУказанияСерий = 14
	|			ТОГДА ТоварыОрдера.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                                    КАК Серия,
	|	ТоварыОрдера.НоменклатураОприходование   КАК НоменклатураОприходование,
	|	ТоварыОрдера.ХарактеристикаОприходование КАК ХарактеристикаОприходование,
	|	ТоварыОрдера.НазначениеОприходование     КАК НазначениеОприходование,
	|	ВЫБОР
	|		КОГДА ТоварыОрдера.СтатусУказанияСерийОприходование = 14
	|			ТОГДА ТоварыОрдера.СерияОприходование
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                                    КАК СерияОприходование,
	|	ТоварыОрдера.Количество                  КАК Количество
	|ПОМЕСТИТЬ ТоварыПересортицы
	|ИЗ
	|	Документ.ОрдерНаОтражениеПересортицыТоваров.Товары КАК ТоварыОрдера
	|ГДЕ
	|	ТоварыОрдера.Ссылка = &ДокументОснование
	|	И (ТоварыОрдера.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|		ИЛИ ТоварыОрдера.Упаковка.ТипУпаковки <> ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТоварныеМеста.Номенклатура,
	|	ТоварныеМеста.Характеристика,
	|	ТоварныеМеста.Назначение,
	|	ВЫБОР
	|		КОГДА ТоварыОрдера.СтатусУказанияСерий = 14
	|			ТОГДА ТоварыОрдера.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	ТоварыОрдера.НоменклатураОприходование,
	|	ТоварыОрдера.ХарактеристикаОприходование,
	|	ТоварыОрдера.НазначениеОприходование,
	|	ВЫБОР
	|		КОГДА ТоварыОрдера.СтатусУказанияСерийОприходование = 14
	|			ТОГДА ТоварыОрдера.СерияОприходование
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	ТоварныеМеста.Количество
	|ИЗ
	|	Документ.ОрдерНаОтражениеПересортицыТоваров.Товары КАК ТоварыОрдера
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТоварыОрдераВТоварныхМестах КАК ТоварныеМеста
	|		ПО ТоварыОрдера.Номенклатура = ТоварныеМеста.Номенклатура
	|			И ТоварыОрдера.Характеристика = ТоварныеМеста.Характеристика
	|			И ТоварыОрдера.Назначение = ТоварныеМеста.Назначение
	|			И ТоварыОрдера.Серия = ТоварныеМеста.Серия
	|ГДЕ
	|	ТоварыОрдера.Ссылка = &ДокументОснование
	|	И ТоварыОрдера.Упаковка.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 4
	|ВЫБРАТЬ
	|	ТоварыПересортицы.Номенклатура                КАК Номенклатура,
	|	ТоварыПересортицы.Характеристика              КАК Характеристика,
	|	ТоварыПересортицы.Назначение                  КАК Назначение,
	|	ТоварыПересортицы.Серия                       КАК Серия,
	|	ТоварыПересортицы.НоменклатураОприходование   КАК НоменклатураОприходование,
	|	ТоварыПересортицы.ХарактеристикаОприходование КАК ХарактеристикаОприходование,
	|	ТоварыПересортицы.НазначениеОприходование     КАК НазначениеОприходование,
	|	ТоварыПересортицы.СерияОприходование          КАК СерияОприходование,
	|	ТоварыПересортицы.Количество                  КАК Количество
	|ИЗ
	|	ТоварыПересортицы КАК ТоварыПересортицы
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТоварыПересортицы.Номенклатура.Наименование,
	|	ТоварыПересортицы.Характеристика.Наименование,
	|	ТоварыПересортицы.Назначение.Наименование,
	|	ТоварыПересортицы.Серия.Наименование
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 5
	|ВЫБРАТЬ
	|	ШапкаДокумента.Склад         КАК Склад,
	|	ШапкаДокумента.Ответственный КАК Ответственный
	|ИЗ
	|	Документ.ОрдерНаОтражениеПересортицыТоваров КАК ШапкаДокумента
	|ГДЕ
	|	ШапкаДокумента.Ссылка = &ДокументОснование
	|";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	РеквизитыДокумента = РезультатЗапроса[5].Выбрать();
	РеквизитыДокумента.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыДокумента);
	
	Товары.Загрузить(РезультатЗапроса[4].Выгрузить());
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если Не ЗначениеЗаполнено(ВидЦены) Тогда
		ВидЦены = Справочники.Склады.УчетныйВидЦены(Склад);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(
			Справочники.ВидыЦен.ПолучитьРеквизитыВидаЦены(ВидЦены).ВалютаЦены);
	КонецЕсли;
	
	ЗаполнитьРеквизитыУчетаДоходовРасходов();
	
	// ИнтеграцияЕГАИС
	ИнтеграцияЕГАИСУТ.ОчиститьПризнакиЕстьАлкогольнаяПродукция(ЭтотОбъект);
	// Конец ИнтеграцияЕГАИС
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыУчетаДоходовРасходов()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПересортицаТоваров.ПриходоватьТоварыПоСебестоимостиСписания,
	|	ПересортицаТоваров.СтатьяДоходов,
	|	ПересортицаТоваров.АналитикаДоходов,
	|	ПересортицаТоваров.СтатьяРасходов,
	|	ПересортицаТоваров.АналитикаРасходов
	|ИЗ
	|	Документ.ПересортицаТоваров КАК ПересортицаТоваров
	|ГДЕ
	|	ПересортицаТоваров.Ответственный = &Ответственный
	|	И ПересортицаТоваров.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПересортицаТоваров.Дата УБЫВ";
	Запрос.УстановитьПараметр("Ответственный", Ответственный);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Если Не Выборка.ПриходоватьТоварыПоСебестоимостиСписания Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		Иначе
			ПриходоватьТоварыПоСебестоимостиСписания = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	&Организация КАК Организация,
	|	&Дата КАК Дата,
	|	&Склад КАК Склад,
	|	Неопределено КАК Партнер,
	|	Неопределено КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	&ВидДеятельностиНДС КАК НалогообложениеНДС,
	|
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Менеджер,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПересортицаТоваров) КАК ХозяйственнаяОперация,
	|	Ложь КАК ЕстьСделкиВТабличнойЧасти,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатурыОприходование КАК АналитикаУчетаНоменклатурыОприходование,
	|	ТаблицаТоваров.НоменклатураОприходование КАК НоменклатураОприходование,
	|	ТаблицаТоваров.ХарактеристикаОприходование КАК ХарактеристикаОприходование,
	|	ТаблицаТоваров.НазначениеОприходование КАК НазначениеОприходование,
	|	ТаблицаТоваров.СерияОприходование КАК СерияОприходование,
	|	ТаблицаТоваров.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.Цена КАК Цена
	|	
	|ПОМЕСТИТЬ ВтТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ТаблицаТоваров.Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатурыОприходование КАК АналитикаУчетаНоменклатурыОприходование,
	|	ТаблицаТоваров.НоменклатураОприходование,
	|	ТаблицаТоваров.ХарактеристикаОприходование,
	|	ТаблицаТоваров.НазначениеОприходование,
	|	ТаблицаТоваров.ВидЗапасов,
	|	ТаблицаТоваров.Количество,
	|	ТаблицаТоваров.Цена,
	|	&Склад КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка) КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	ВтТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОприходование КАК АналитикаУчетаНоменклатурыОприходование,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.ВидЗапасовОприходование КАК ВидЗапасовОприходование,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.Сумма КАК Сумма,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	&Склад КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОприходование КАК АналитикаУчетаНоменклатурыОприходование,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	АналитикаОприходование.Номенклатура КАК НоменклатураОприходование,
	|	АналитикаОприходование.Характеристика КАК ХарактеристикаОприходование,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.ВидЗапасовОприходование КАК ВидЗапасовОприходование,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.Сумма КАК Сумма,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикаОприходование
	|	ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОприходование = АналитикаОприходование.КлючАналитики
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.НоменклатураОприходование КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &Проведен
	|			ТОГДА ТаблицаТоваров.ВидЗапасов
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	КОНЕЦ КАК ТекущийВидЗапасов,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОприходованиеТоваров) КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеОрганизации,
	|	НЕОПРЕДЕЛЕНО КАК ВладелецТовара,
	|	ЗНАЧЕНИЕ(Справочник.ВидыЦен.ПустаяСсылка) КАК ВидЦены
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.ВидЗапасов = ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	ИЛИ &ПерезаполнитьВидыЗапасов
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ВидДеятельностиНДС", ВидДеятельностиНДС);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ТаблицаТоваров", Товары);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов);
	Запрос.УстановитьПараметр("Проведен", Проведен);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект, Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

Процедура СформироватьВременнуюТаблицуТоваровИАналитики(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ТаблицаТоваров.Серия,
	|	ТаблицаТоваров.Склад,
	|
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Менеджер,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|
	|	ТаблицаТоваров.Количество КАК Количество
	|	
	|ПОМЕСТИТЬ ТаблицаТоваровИАналитики
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокумента КАК ТаблицаДанныхДокумента
	|	ПО
	|		Истина
	|;
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ЗаполнитьНоменклатуруОприходованиеВидовЗапасов() Экспорт
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры");
	Для Каждого СтрокаТоваров Из Товары Цикл

		КоличествоТоваров = СтрокаТоваров.Количество;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл

			Если СтрокаЗапасов.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Количество = Мин(КоличествоТоваров, СтрокаЗапасов.Количество);

			НоваяСтрока = ВидыЗапасов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
			
			НоваяСтрока.АналитикаУчетаНоменклатурыОприходование = СтрокаТоваров.АналитикаУчетаНоменклатурыОприходование;
			НоваяСтрока.ВидЗапасовОприходование		= СтрокаТоваров.ВидЗапасов;
			НоваяСтрока.Сумма						= ?(Не ПриходоватьТоварыПоСебестоимостиСписания, Количество * СтрокаТоваров.Цена, 0);
			НоваяСтрока.Количество					= Количество;

			СтрокаЗапасов.Количество = СтрокаЗапасов.Количество - НоваяСтрока.Количество;
			
			КоличествоТоваров = КоличествоТоваров - НоваяСтрока.Количество;

			Если КоличествоТоваров = 0 Тогда
				Прервать;
			КонецЕсли;

		КонецЦикла;
		
	КонецЦикла;
	
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(Новый Структура("Количество", 0));
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры 

// Заполняет аналитики учета номенклатуры. Используется в отчете ОстаткиТоваровОрганизаций.
Процедура ЗаполнитьАналитикиУчетаНоменклатуры() Экспорт
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(Перечисления.ХозяйственныеОперации.ПересортицаТоваров, Склад, Подразделение, Неопределено);
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета);
	
	ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
	ИменаПолей.Номенклатура = "НоменклатураОприходование";
	ИменаПолей.Характеристика = "ХарактеристикаОприходование";
	ИменаПолей.Серия = "СерияОприходование";
	ИменаПолей.АналитикаУчетаНоменклатуры = "АналитикаУчетаНоменклатурыОприходование";
	ИменаПолей.Назначение = "НазначениеОприходование";
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета, ИменаПолей);

КонецПроцедуры

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();
	ЗапасыСервер.ЗаполнитьВидыЗапасовПоУмолчанию(МенеджерВременныхТаблиц, Товары);
	ПерезаполнитьВидыЗапасов = ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	Если Не Проведен
	 ИЛИ ПерезаполнитьВидыЗапасов
	 ИЛИ ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	 ИЛИ ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
	 
	 	ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов();
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект,
																				МенеджерВременныхТаблиц,
																				Отказ,
																				ПараметрыЗаполнения);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД", "Количество");
		
		ЗаполнитьНоменклатуруОприходованиеВидовЗапасов();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	// Приходы в регистр (сторно расхода из регистра) контролируем при перепроведении и отмене проведения
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ТоварыОрганизаций);
	КонецЕсли;
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура ПроверитьСтавкиНДС(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура КАК НоменклатураСписание,
	|	ТаблицаТовары.НоменклатураОприходование,
	|	ТаблицаТовары.НомерСтроки
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	ВЫРАЗИТЬ(ТаблицаТовары.НоменклатураСписание КАК Справочник.Номенклатура).СтавкаНДС <> ВЫРАЗИТЬ(ТаблицаТовары.НоменклатураОприходование КАК Справочник.Номенклатура).СтавкаНДС
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ТаблицаТовары", Товары.Выгрузить());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ТекстСообщения = НСтр("ru='Нельзя зачесть по пересортице, т.к. у списываемой и приходуемой номенклатуры не равны ставки НДС'");

		Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Выборка.НомерСтроки, "Номенклатура");
			
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,Поле,"Объект",Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеНомеровГТД(Отказ)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ИсходнаяТаблица.НомерСтроки КАК НомерСтроки,
	|	ИсходнаяТаблица.НоменклатураОприходование КАК Номенклатура,
	|	ИсходнаяТаблица.НомерГТД КАК НомерГТД
	|
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	&ТаблицаТовары КАК ИсходнаяТаблица
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.НомерГТД = ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)
	|	И ТаблицаТовары.Номенклатура.ВестиУчетПоГТД
	|");
	ТаблицаТовары = Товары.Выгрузить(, "НомерСтроки, НоменклатураОприходование, НомерГТД");
	Запрос.УстановитьПараметр("ТаблицаТовары", ТаблицаТовары);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не заполнена колонка ""Номер ГТД"" в строке %1 списка ""Товары""'"),
			Выборка.НомерСтроки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"Товары[" + (Выборка.НомерСтроки - 1) + "].НомерГТД",
			,
			Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Организация, Дата, Склад";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Функция ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|////////////////////////////////////////////////////////////////////////////////
	|// Проверим соответствие табличных частей Товары и ВидыЗапасов
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.НоменклатураОприходование,
	|	ТаблицаТоваров.ХарактеристикаОприходование
	|ИЗ (
	|	ВЫБРАТЬ
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.НоменклатураОприходование КАК НоменклатураОприходование,
	|		ТаблицаТоваров.ХарактеристикаОприходование КАК ХарактеристикаОприходование,
	|		ТаблицаТоваров.ВидЗапасов КАК ВидЗапасовОприходование,
	|		ТаблицаТоваров.Количество КАК Количество,
	|		ВЫРАЗИТЬ(ТаблицаТоваров.Количество * ТаблицаТоваров.Цена КАК ЧИСЛО(15,2)) КАК Сумма
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаВидыЗапасов.НоменклатураОприходование КАК НоменклатураОприходование,
	|		ТаблицаВидыЗапасов.ХарактеристикаОприходование КАК ХарактеристикаОприходование,
	|		ТаблицаВидыЗапасов.ВидЗапасовОприходование КАК ВидЗапасовОприходование,
	|		-ТаблицаВидыЗапасов.Количество КАК Количество,
	|		-ТаблицаВидыЗапасов.Сумма КАК Сумма
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|	) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.НоменклатураОприходование,
	|	ТаблицаТоваров.ХарактеристикаОприходование,
	|	ТаблицаТоваров.ВидЗапасовОприходование
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТоваров.Количество) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.Сумма) <> 0
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|");
	Запрос.УстановитьПараметр("ПриходПоСебестоимости", ПриходоватьТоварыПоСебестоимостиСписания);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;

	РезультатЗапрос = Запрос.Выполнить();
	
	Возврат (Не РезультатЗапрос.Пустой());
	
КонецФункции

Функция ПараметрыЗаполненияВидовЗапасов()
	
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ПараметрыЗаполнения.НалогообложениеНДС = ВидДеятельностиНДС;
	ПараметрыЗаполнения.ДокументДелаетИПриходИРасход = Истина;

	Возврат ПараметрыЗаполнения;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
