﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	СозданиеНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Добавляет команду создания документа "Корректировка по ордеру на товары".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.КорректировкаПоОрдеруНаТовары) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.КорректировкаПоОрдеруНаТовары.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.КорректировкаПоОрдеруНаТовары);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьАдресноеХранение";
	

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

//Имена реквизитов, от значений которых зависят параметры указания серий
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	ИменаРеквизитов = "Склад,Помещение,Дата";
	
	Возврат ИменаРеквизитов;
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//  Объект	 - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
// 
// Возвращаемое значение:
//  Структура - состав полей задается в функции ОбработкаТабличнойЧастиКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	ПараметрыУказанияСерий = НоменклатураКлиентСервер.ПараметрыУказанияСерий();
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.КорректировкаПоОрдеруНаТовары";
	
	ПараметрыСерийСклада = СкладыСервер.ИспользованиеСерийНаСкладе(Объект.Склад, Ложь);
	
	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры  = ПараметрыСерийСклада.ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям = ПараметрыСерийСклада.УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерий.СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.КонтрольОтгрузки);
	ПараметрыУказанияСерий.ИспользоватьАдресноеХранение = Истина;
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("Упаковка");
	ПараметрыУказанияСерий.ИмяПоляКоличество = "КоличествоУпаковок";	
	
	ПараметрыУказанияСерий.ЭтоОрдер = Истина;
	ПараметрыУказанияСерий.ИмяТЧСерии = "Товары";
	ПараметрыУказанияСерий.ИмяПоляПомещение = "Помещение";
	ПараметрыУказанияСерий.Дата = Объект.Дата;
	ПараметрыУказанияСерий.ТолькоСерииДляСебестоимости = Ложь;
	
	Возврат ПараметрыУказанияСерий;
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//		ПараметрыУказанияСерий - Структура - состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий
//	Возвращаемое значение:
//		Строка - текст запроса
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Товары.Номенклатура,
	|	Товары.Серия,
	|	Товары.СтатусУказанияСерий,
	|	Товары.НомерСтроки
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.СтатусУказанияСерий КАК СтарыйСтатусУказанияСерий,
	|	ВЫБОР
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL 
	|			ТОГДА 0
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтгрузки
	|					ТОГДА ВЫБОР
	|							КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
	|								ТОГДА ВЫБОР
	|										КОГДА Товары.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|											ТОГДА 13
	|										ИНАЧЕ 14
	|									КОНЕЦ
	|							ИНАЧЕ ВЫБОР
	|									КОГДА Товары.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|										ТОГДА 9
	|									ИНАЧЕ 10
	|								КОНЕЦ
	|						КОНЕЦ
	|				КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтбора
	|					ТОГДА ВЫБОР
	|							КОГДА Товары.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|								ТОГДА 7
	|							ИНАЧЕ 8
	|						КОНЕЦ
	|				КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПоФактуОтбора
	|						И ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьОстаткиСерий
	|					ТОГДА ВЫБОР
	|							КОГДА Товары.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|								ТОГДА 3
	|							ИНАЧЕ 4
	|						КОНЕЦ
	|				ИНАЧЕ 0
	|			КОНЕЦ
	|	КОНЕЦ КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ ТаблицаСтатусов
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|			ПО ПолитикиУчетаСерий.Склад = Склады.Ссылка
	|		ПО (ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры = ПолитикиУчетаСерий.Ссылка)
	|			И (ПолитикиУчетаСерий.Склад = &Склад)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСтатусов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаСтатусов.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ИЗ
	|	ТаблицаСтатусов КАК ТаблицаСтатусов
	|ГДЕ
	|	ТаблицаСтатусов.СтарыйСтатусУказанияСерий <> ТаблицаСтатусов.СтатусУказанияСерий
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат ТекстЗапроса;

КонецФункции

// Инициализирует параметры, обслуживающие выбор назначений в формах документа.
// 
//  Возвращаемое значение:
//  Структура - структура параметров, см. Справочники.Назначения.МакетФормыВыбораНазначений().
//
Функция МакетФормыВыбораНазначений() Экспорт
	
	МакетФормы = Справочники.Назначения.МакетФормыВыбораНазначений();
	
	ШаблонНазначения = Справочники.Назначения.ДобавитьШаблонНазначений(МакетФормы);
	ШаблонНазначения.ДвиженияПоСкладскимРегистрам = "ИСТИНА";
	
	// Потребности в товарах на складе.
	ОписаниеКолонок = Справочники.Назначения.ДобавитьОписаниеКолонок(МакетФормы, "ОбеспечениеЗаказов", Истина, "Объект.Товары.Назначение");
	ОписаниеКолонок.Колонки.НайтиПоЗначению("Потребность").Пометка = Истина;
	
	ОписаниеКолонок.ПутиКДанным.Номенклатура     = "Объект.Товары.Номенклатура";
	ОписаниеКолонок.ПутиКДанным.Характеристика   = "Объект.Товары.Характеристика";
	ОписаниеКолонок.ПутиКДанным.Склад            = "Объект.Склад";
	
	Возврат МакетФормы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	
	ТекстЗапросаТаблицаТоварыКОтбору(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаТоварыКОформлениюИзлишковНедостач(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаТоварыВЯчейках(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДвиженияСерийТоваров(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаТоварыНаСкладах(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаСвободныеОстатки(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаОбеспечениеЗаказов(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеШапки.Дата КАК Период,
	|	ДанныеШапки.Склад КАК Склад,
	|	ДанныеШапки.Ордер КАК Ордер,
	|	ДанныеШапки.ОрдерПолучатель КАК ОрдерПолучатель,
	|	ДанныеШапки.Помещение КАК Помещение,
	|	ДанныеШапки.ЗонаОтгрузки КАК ЗонаОтгрузки
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары КАК ДанныеШапки
	|ГДЕ
	|	ДанныеШапки.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",                       Реквизиты.Период);
	Запрос.УстановитьПараметр("Склад",                        Реквизиты.Склад);
	Запрос.УстановитьПараметр("Ордер",                        Реквизиты.Ордер);
	Запрос.УстановитьПараметр("ОрдерПолучатель",              Реквизиты.ОрдерПолучатель);
	Запрос.УстановитьПараметр("Помещение",                    Реквизиты.Помещение);
	Запрос.УстановитьПараметр("ЗонаОтгрузки",                 Реквизиты.ЗонаОтгрузки);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаТоварыКОтбору(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ТоварыКОтбору";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Назначение.ДвиженияПоСкладскимРегистрам, ЛОЖЬ)
	|			ТОГДА ТаблицаТовары.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ КАК Назначение,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (6, 8, 10, 14)
	|			ТОГДА ТаблицаТовары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	&Ордер КАК Распоряжение,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Упаковка.ТипУпаковки, НЕОПРЕДЕЛЕНО) = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
	|			ТОГДА ТаблицаТовары.Упаковка
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|	КОНЕЦ КАК ТоварноеМесто,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Упаковка.ТипУпаковки, НЕОПРЕДЕЛЕНО) = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
	|			ТОГДА ТаблицаТовары.КоличествоУпаковок
	|		ИНАЧЕ ТаблицаТовары.Количество
	|	КОНЕЦ КАК Отобрано,
	|	0 КАК КОтбору
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И (ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьНедостачу)
	|			ИЛИ ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ПеренестиВДругойОрдер))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|	&Период,
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Назначение.ДвиженияПоСкладскимРегистрам, ЛОЖЬ)
	|			ТОГДА ТаблицаТовары.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (6, 8, 10, 14)
	|			ТОГДА ТаблицаТовары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	&Ордер,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Упаковка.ТипУпаковки, НЕОПРЕДЕЛЕНО) = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
	|			ТОГДА ТаблицаТовары.Упаковка
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Упаковка.ТипУпаковки, НЕОПРЕДЕЛЕНО) = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
	|			ТОГДА ТаблицаТовары.КоличествоУпаковок
	|		ИНАЧЕ ТаблицаТовары.Количество
	|	КОНЕЦ,
	|	0
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОставитьВЗонеОтгрузки)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	&Период,
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Назначение.ДвиженияПоСкладскимРегистрам, ЛОЖЬ)
	|			ТОГДА ТаблицаТовары.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (6, 8, 10, 14)
	|			ТОГДА ТаблицаТовары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек)
	|			ТОГДА &Ордер
	|		ИНАЧЕ &ОрдерПолучатель
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Упаковка.ТипУпаковки, НЕОПРЕДЕЛЕНО) = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
	|			ТОГДА ТаблицаТовары.Упаковка
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Упаковка.ТипУпаковки, НЕОПРЕДЕЛЕНО) = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
	|			ТОГДА ТаблицаТовары.КоличествоУпаковок
	|		ИНАЧЕ ТаблицаТовары.Количество
	|	КОНЕЦ,
	|	0
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И (ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек)
	|			ИЛИ ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ПеренестиВДругойОрдер))";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаТоварыКОформлениюИзлишковНедостач(Запрос, ТекстыЗапроса, Регистры)
	ИмяРегистра = "ТоварыКОформлениюИзлишковНедостач";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	&Склад КАК Склад,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Назначение.ДвиженияПоСкладскимРегистрам, ЛОЖЬ)
	|			ТОГДА ТаблицаТовары.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ КАК Назначение,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий = 14
	|			ТОГДА ТаблицаТовары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	ТаблицаТовары.Количество КАК КОформлениюАктов
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	&Период,
	|	&Склад,
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Назначение.ДвиженияПоСкладскимРегистрам, ЛОЖЬ)
	|			ТОГДА ТаблицаТовары.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий = 14
	|			ТОГДА ТаблицаТовары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	ТаблицаТовары.Количество
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И (ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишекОставитьВЗонеОтгрузки)
	|			ИЛИ ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек))";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаТоварыВЯчейках(Запрос, ТекстыЗапроса, Регистры)
	ИмяРегистра = "ТоварыВЯчейках";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(Товары.Назначение.ДвиженияПоСкладскимРегистрам, ЛОЖЬ)
	|			ТОГДА Товары.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ КАК Назначение,
	|	Товары.Серия КАК Серия,
	|	&ЗонаОтгрузки КАК Ячейка,
	|	ВЫБОР
	|		КОГДА Товары.Упаковка.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка)
	|			ТОГДА Товары.Упаковка
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|	КОНЕЦ КАК Упаковка,
	|	ВЫБОР
	|		КОГДА Товары.Упаковка.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка)
	|			ТОГДА Товары.КоличествоУпаковок
	|		ИНАЧЕ Товары.Количество
	|	КОНЕЦ КАК ВНаличии
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|	И (Товары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишекОставитьВЗонеОтгрузки)
	|			ИЛИ Товары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОставитьВЗонеОтгрузки))";	
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияСерийТоваров(Запрос, ТекстыЗапроса, Регистры)
	ИмяРегистра = "ДвиженияСерийТоваров";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаСерии.Номенклатура КАК Номенклатура,
	|	ТаблицаСерии.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаСерии.Назначение.ДвиженияПоСкладскимРегистрам, ЛОЖЬ)
	|			ТОГДА ТаблицаСерии.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ КАК Назначение,
	|	ТаблицаСерии.Серия КАК Серия,
	|	ТаблицаСерии.Количество КАК Количество,
	|	&Склад КАК Отправитель,
	|	&Помещение КАК ПомещениеОтправителя,
	|	&Склад КАК Получатель,
	|	&Помещение КАК ПомещениеПолучателя,
	|	ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.КонтрольОтгрузки) КАК СкладскаяОперация,
	|	&Ордер  КАК Документ,
	|	&Период КАК Период,
	|	ИСТИНА КАК ЭтоСкладскоеДвижение
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК ТаблицаСерии
	|
	|ГДЕ
	|	ТаблицаСерии.Ссылка = &Ссылка
	|	И ТаблицаСерии.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)";	
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаТоварыНаСкладах(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ТоварыНаСкладах";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	&Склад КАК Склад,
	|	&Помещение КАК Помещение,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Назначение.ДвиженияПоСкладскимРегистрам, ЛОЖЬ)
	|			ТОГДА ТаблицаТовары.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ КАК Назначение,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (4, 6, 8, 10, 14)
	|			ТОГДА ТаблицаТовары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	ТаблицаТовары.Количество КАК ВНаличии
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|	&Период,
	|	&Склад,
	|	&Помещение,
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Назначение.ДвиженияПоСкладскимРегистрам, ЛОЖЬ)
	|			ТОГДА ТаблицаТовары.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (4, 6, 8, 10, 14)
	|			ТОГДА ТаблицаТовары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	ТаблицаТовары.Количество
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьНедостачу)";	
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаОбеспечениеЗаказов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОбеспечениеЗаказов";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Период                                КАК Период,
	|	ТаблицаТовары.Номенклатура             КАК Номенклатура,
	|	ТаблицаТовары.Характеристика           КАК Характеристика,
	|	&Склад                                 КАК Склад,
	|	ТаблицаТовары.Назначение               КАК Назначение,
	|	-ТаблицаТовары.Количество              КАК КЗаказу,
	|	ТаблицаТовары.Количество               КАК НаличиеПодЗаказ
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек)
	|	И ТаблицаТовары.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Период                                КАК Период,
	|	ТаблицаТовары.Номенклатура             КАК Номенклатура,
	|	ТаблицаТовары.Характеристика           КАК Характеристика,
	|	&Склад                                 КАК Склад,
	|	ТаблицаТовары.Назначение               КАК Назначение,
	|	ТаблицаТовары.Количество               КАК КЗаказу,
	|	-ТаблицаТовары.Количество              КАК НаличиеПодЗаказ
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьНедостачу)
	|	И ТаблицаТовары.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаСвободныеОстатки(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СвободныеОстатки";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Период                                КАК Период,
	|	&Склад                                 КАК Склад,
	|	ТаблицаТовары.Номенклатура             КАК Номенклатура,
	|	ТаблицаТовары.Характеристика           КАК Характеристика,
	|	ТаблицаТовары.Количество               КАК ВНаличии,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			ТОГДА ТаблицаТовары.Количество
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ВРезервеПодЗаказ
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период                                КАК Период,
	|	&Склад                                 КАК Склад,
	|	ТаблицаТовары.Номенклатура             КАК Номенклатура,
	|	ТаблицаТовары.Характеристика           КАК Характеристика,
	|	ТаблицаТовары.Количество               КАК ВНаличии,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			ТОГДА ТаблицаТовары.Количество
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ВРезервеПодЗаказ
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьНедостачу)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает таблицу состояний и дат пересчетов ячеек после проведения проверки отгрузки товаров
//	Возвращаемое значение:
//		ТаблицаЗначений - таблица значений с состояниями и датами пересчетов ячеек
//
Функция ТаблицаСостоянийПересчетовЯчеек(ДокументСсылка, Статус) Экспорт
	
	ТаблицаСостоянийПересчетовЯчеек = Новый ТаблицаЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтборРазмещениеТоваровТоварыОтбор.Номенклатура,
	|	ОтборРазмещениеТоваровТоварыОтбор.Характеристика,
	|	ОтборРазмещениеТоваровТоварыОтбор.Серия,
	|	ОтборРазмещениеТоваровТоварыОтбор.Упаковка,
	|	ОтборРазмещениеТоваровТоварыОтбор.Ячейка
	|ПОМЕСТИТЬ ТоварыОтбор
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары КАК КорректировкаПоОрдеруНаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтборРазмещениеТоваров.ТоварыОтбор КАК ОтборРазмещениеТоваровТоварыОтбор
	|		ПО КорректировкаПоОрдеруНаТовары.Ордер = ОтборРазмещениеТоваровТоварыОтбор.Ссылка.Распоряжение
	|ГДЕ
	|	КорректировкаПоОрдеруНаТовары.Ссылка = &ДокументСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КорректировкаПоОрдеруНаТоварыТовары.Номенклатура,
	|	КорректировкаПоОрдеруНаТоварыТовары.Характеристика,
	|	КорректировкаПоОрдеруНаТоварыТовары.Серия,
	|	КорректировкаПоОрдеруНаТоварыТовары.Упаковка
	|ПОМЕСТИТЬ ТоварыНедостача
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК КорректировкаПоОрдеруНаТоварыТовары
	|ГДЕ
	|	КорректировкаПоОрдеруНаТоварыТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьНедостачу)
	|	И КорректировкаПоОрдеруНаТоварыТовары.Ссылка = &ДокументСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КорректировкаПоОрдеруНаТоварыТовары.Номенклатура,
	|	КорректировкаПоОрдеруНаТоварыТовары.Характеристика,
	|	КорректировкаПоОрдеруНаТоварыТовары.Серия,
	|	КорректировкаПоОрдеруНаТоварыТовары.Упаковка
	|ПОМЕСТИТЬ ТоварыИзлишек
	|ИЗ
	|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК КорректировкаПоОрдеруНаТоварыТовары
	|ГДЕ
	|	КорректировкаПоОрдеруНаТоварыТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек)
	|	И КорректировкаПоОрдеруНаТоварыТовары.Ссылка = &ДокументСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВнутреннийЗапрос.Ячейка,
	|	ЗНАЧЕНИЕ(Перечисление.СостоянияПересчетовЯчеек.ТребуетсяПересчет) КАК Состояние,
	|	ВЫРАЗИТЬ(&ДокументСсылка КАК Документ.КорректировкаПоОрдеруНаТовары).Дата КАК ДатаДокумента
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыОтбор.Ячейка КАК Ячейка
	|	ИЗ
	|		ТоварыОтбор КАК ТоварыОтбор
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТоварыНедостача КАК ТоварыНедостача
	|			ПО ТоварыОтбор.Номенклатура = ТоварыНедостача.Номенклатура
	|				И ТоварыОтбор.Характеристика = ТоварыНедостача.Характеристика
	|				И ТоварыОтбор.Серия = ТоварыНедостача.Серия
	|				И ТоварыОтбор.Упаковка = ТоварыНедостача.Упаковка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТоварыВЯчейкахОстатки.Ячейка
	|	ИЗ
	|		РегистрНакопления.ТоварыВЯчейках.Остатки(
	|				,
	|				(Номенклатура, Характеристика, Серия, Упаковка) В
	|					(ВЫБРАТЬ
	|						ТоварыИзлишек.Номенклатура,
	|						ТоварыИзлишек.Характеристика,
	|						ТоварыИзлишек.Серия,
	|						ТоварыИзлишек.Упаковка
	|					ИЗ
	|						ТоварыИзлишек КАК ТоварыИзлишек)) КАК ТоварыВЯчейкахОстатки
	|	ГДЕ
	|		ТоварыВЯчейкахОстатки.ВНаличииОстаток > 0) КАК ВнутреннийЗапрос";
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	ТаблицаСостоянийПересчетовЯчеек = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаСостоянийПересчетовЯчеек;
	
КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.КорректировкаПоОрдеруНаТовары"; 
	
	ЗначенияПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров = Новый Структура;
	
	Если ИмяРегистра = "ОбеспечениеЗаказов" Тогда
	
		ТекстЗапроса = ТекстЗапросаТаблицаОбеспечениеЗаказов(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ТаблицаТовары";
		
	ИначеЕсли ИмяРегистра = "СвободныеОстатки" Тогда
	
		ТекстЗапроса = ТекстЗапросаТаблицаСвободныеОстатки(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ТаблицаТовары";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(ТекстЗапроса,
																								ПолноеИмяДокумента,
																								СинонимТаблицыДокумента,
																								ПереопределениеРасчетаПараметров);

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли