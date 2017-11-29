﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Документы.ПриходныйКассовыйОрдер.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	Документы.РасходныйКассовыйОрдер.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	Документы.СписаниеБезналичныхДенежныхСредств.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	СозданиеНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Добавляет команду создания документа "Распоряжение".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.РаспоряжениеНаПеремещениеДенежныхСредств) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РаспоряжениеНаПеремещениеДенежныхСредств.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.РаспоряжениеНаПеремещениеДенежныхСредств);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьЗаявкиНаРасходованиеДенежныхСредств";
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

// Процедура заполняет массивы реквизитов, зависимых от хозяйственной операции документа.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Выбранная хозяйственная операция
//	МассивВсехРеквизитов - Массив - Массив всех имен реквизитов, зависимых от хозяйственной операции
//	МассивРеквизитовОперации - Массив - Массив имен реквизитов, используемых в выбранной хозяйственной операции
//
Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(ХозяйственнаяОперация, МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("БанковскийСчет");
	МассивВсехРеквизитов.Добавить("Касса");
	МассивВсехРеквизитов.Добавить("БанковскийСчетПолучатель");
	МассивВсехРеквизитов.Добавить("КассаПолучатель");
	МассивВсехРеквизитов.Добавить("Подразделение");
	
	МассивРеквизитовОперации = Новый Массив;
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк Тогда
		МассивРеквизитовОперации.Добавить("Касса");
		МассивРеквизитовОперации.Добавить("БанковскийСчетПолучатель");
		МассивРеквизитовОперации.Добавить("Подразделение");
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк Тогда
		МассивРеквизитовОперации.Добавить("Касса");
		МассивРеквизитовОперации.Добавить("БанковскийСчетПолучатель");
		МассивРеквизитовОперации.Добавить("Подразделение");
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу Тогда
		МассивРеквизитовОперации.Добавить("Касса");
		МассивРеквизитовОперации.Добавить("КассаПолучатель");
		МассивРеквизитовОперации.Добавить("Подразделение");
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет Тогда
		МассивРеквизитовОперации.Добавить("БанковскийСчет");
		МассивРеквизитовОперации.Добавить("БанковскийСчетПолучатель");
		МассивРеквизитовОперации.Добавить("Подразделение");
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка Тогда
		МассивРеквизитовОперации.Добавить("БанковскийСчет");
		МассивРеквизитовОперации.Добавить("КассаПолучатель");
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СнятиеНаличныхДенежныхСредств Тогда
		МассивРеквизитовОперации.Добавить("БанковскийСчет");
		МассивРеквизитовОперации.Добавить("КассаПолучатель");
		МассивРеквизитовОперации.Добавить("Подразделение");
		
	КонецЕсли;
	
КонецПроцедуры

// Функция определяет реквизиты документе.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документа
//
// Возвращаемое значение:
//	Структура - реквизиты выбранного документа
//
Функция РеквизитыДокумента(ДокументСсылка) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.Статус КАК Статус,
	|	ДанныеДокумента.Валюта КАК Валюта
	|ИЗ
	|	Документ.РаспоряжениеНаПеремещениеДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &ДокументСсылка
	|");
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Организация = Выборка.Организация;
		Подразделение = Выборка.Подразделение;
		Статус = Выборка.Статус;
		Валюта = Выборка.Валюта;
	Иначе
		Организация = Справочники.Организации.ПустаяСсылка();
		Подразделение = Справочники.СтруктураПредприятия.ПустаяСсылка();
		Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.ПустаяСсылка();
		Валюта = Справочники.Валюты.ПустаяСсылка();
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Организация", Организация);
	СтруктураРеквизитов.Вставить("Подразделение", Подразделение);
	СтруктураРеквизитов.Вставить("Статус", Статус);
	СтруктураРеквизитов.Вставить("Валюта", Валюта);
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт
	
	ИсточникиДанных = Новый Соответствие;
	
	Возврат ИсточникиДанных;
	
КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос();
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.РаспоряжениеНаПеремещениеДенежныхСредств";
	
	Если ИмяРегистра = "ДенежныеСредстваКВыплате" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаДенежныеСредстваКВыплате(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров.Вставить("ИспользоватьЗаявкиНаРасходованиеДенежныхСредств",
		ПолучитьФункциональнуюОпцию("ИспользоватьЗаявкиНаРасходованиеДенежныхСредств"));
	Результат.ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
		ТекстЗапроса, ПолноеИмяДокумента, СинонимТаблицыДокумента);
	
	Возврат Результат;
	
КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаДенежныеСредстваКВыплате(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.БанковскийСчет КАК БанковскийСчет,
	|	ДанныеДокумента.Касса КАК Касса,
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельности
	|ИЗ
	|	Документ.РаспоряжениеНаПеремещениеДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("АналитикаУчетаПоПартнерам", РегистрыСведений.АналитикаУчетаПоПартнерам.ЗначениеКлючаАналитики(Реквизиты));
	Запрос.УстановитьПараметр("ИспользоватьЗаявкиНаРасходованиеДенежныхСредств", ПолучитьФункциональнуюОпцию("ИспользоватьЗаявкиНаРасходованиеДенежныхСредств"));
	Запрос.УстановитьПараметр("СтатьяДвиженияДенежныхСредств",
		Справочники.СтатьиДвиженияДенежныхСредств.ПредопределеннаяСтатьяДДС(Реквизиты.ХозяйственнаяОперация, Реквизиты.Валюта));
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаДенежныеСредстваКВыплате(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваКВыплате";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ДанныеДокумента.ДатаПлатежа <> ДАТАВРЕМЯ(1,1,1) ТОГДА
	|		ДанныеДокумента.ДатаПлатежа
	|	ИНАЧЕ
	|		ДанныеДокумента.Дата
	|	КОНЕЦ КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Ссылка КАК ЗаявкаНаРасходованиеДенежныхСредств,
	|	
	|	ВЫБОР КОГДА &ХозяйственнаяОперация В (
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СдачаДенежныхСредствВБанк),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу))
	|	ТОГДА
	|		&Касса
	|	КОГДА &ХозяйственнаяОперация В (
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СнятиеНаличныхДенежныхСредств))
	|	ТОГДА
	|		&БанковскийСчет
	|	КОНЕЦ КАК БанковскийСчетКасса,
	|	
	|	&Организация КАК Получатель,
	|	&Организация КАК Организация,
	|	
	|	ДанныеДокумента.СуммаДокумента КАК Сумма,
	|	
	|	ДанныеДокумента.ХозяйственнаяОперация КАК ХозяйственнаяОперация
	|	
	|ИЗ
	|	Документ.РаспоряжениеНаПеремещениеДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И &ИспользоватьЗаявкиНаРасходованиеДенежныхСредств
	|	И ДанныеДокумента.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.Отклонено)
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция СформироватьЗапросПроверкиПриСменеСтатуса(МассивДокументов, НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств[НовыйСтатус];
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаДокументов.Ссылка КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаДокументов.Ссылка) КАК Представление,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаДокументов.Статус) КАК ПредставлениеТекущегоСтатуса,
	|	ПРЕДСТАВЛЕНИЕ(&Статус) КАК ПредставлениеНовогоСтатуса,
	|	ВЫБОР
	|		КОГДА ТаблицаДокументов.Статус = &Статус
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СтатусСовпадает,
	|	ТаблицаДокументов.Проведен КАК Проведен,
	|	ТаблицаДокументов.ПометкаУдаления КАК ПометкаУдаления,
	|	ИСТИНА КАК ЗаписьПроведением
	|ИЗ
	|	Документ.РаспоряжениеНаПеремещениеДенежныхСредств КАК ТаблицаДокументов
	|ГДЕ
	|	ТаблицаДокументов.Ссылка В(&МассивДокументов)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Статус", ЗначениеНовогоСтатуса);
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	Возврат Запрос;
	
КонецФункции

Функция ПроверкаПередСменойСтатуса(ВыборкаПроверки, НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	Возврат Истина; // Для документа "РаспоряжениеНаПеремещениеДенежныхСредств" отсутствуют дополнительные проверки
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
