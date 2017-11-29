﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ТипНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Номенклатура, "ТипНоменклатуры");
		ЭтоРабота = ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа;
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	// Если используется выбор групп и элементов, то форма вызвана из платформенного поиска 
	Если Не Параметры.Свойство("Источник")
		И Не Параметры.Свойство("ИмяОбъекта")
		И ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		ВызватьИсключение НСтр("ru='Не реализован выбор назначения из этой формы. Необходимо настроить связи параметров выбора'"); 	
	КонецЕсли; 
	
	Параметры.Свойство("Источник", Источник);
	Параметры.Свойство("ИмяОбъекта", ИмяОбъекта);
	Параметры.Свойство("Распоряжение", Распоряжение);
	Параметры.Свойство("Ячейка", Ячейка);
	Параметры.Свойство("ВидОперации", ВидОперации);
	Параметры.Свойство("РежимВыбораНазначений", РежимВыбора);
	
	Параметры.Свойство("ТипНазначения", ТипНазначения);
	ВключатьЗаказыПереработчиков =
		Не Параметры.Свойство("ВключатьЗаказыПереработчиков")
		Или Параметры.ВключатьЗаказыПереработчиков;
	
	Если ЗначениеЗаполнено(ИмяОбъекта) Тогда
		Если ИмяОбъекта = "Обработка.ПроверкаКоличестваТоваровВДокументе" 
			Или ИмяОбъекта = "Обработка.ПроверкаКоличестваТоваровВПриходномОрдере" Тогда
			Элементы.Потребность.Видимость = Ложь;
			Элементы.Обеспечено.Видимость = Ложь;
		КонецЕсли;	
	ИначеЕсли Источник <> Неопределено Тогда
		Если ТипЗнч(Источник) = Тип("ДокументСсылка.ПриходныйОрдерНаТовары") 
				И ЗначениеЗаполнено(Распоряжение)
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.ОтборРазмещениеТоваров") 
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.РасходныйОрдерНаТовары") Тогда
			Элементы.Потребность.Видимость = Истина;
		ИначеЕсли ТипЗнч(Источник) = Тип("ДокументСсылка.ПересчетТоваров") 
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.ОрдерНаОтражениеИзлишковТоваров")
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.ОрдерНаОтражениеНедостачТоваров")
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.ОрдерНаОтражениеПорчиТоваров")
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.СписаниеНедостачТоваров")	
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.ПорчаТоваров")
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.ОприходованиеИзлишковТоваров")
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.ПересортицаТоваров")
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.ВводОстатков")
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.КорректировкаПриобретения") 
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.ВозвратТоваровПоставщику")
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.КорректировкаРеализации") 
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.КорректировкаПоОрдеруНаТовары")
			Или ТипЗнч(Источник) = Тип("ДокументСсылка.ПересортицаТоваров")
			Или РежимВыбора = "Все" Тогда
		Иначе
			Элементы.Потребность.Видимость = Истина;
			Элементы.Обеспечено.Видимость = Истина;
		КонецЕсли;	
	Иначе
		Элементы.Потребность.Видимость = Ложь;
		Элементы.Обеспечено.Видимость = Ложь;
	КонецЕсли;	
	
	УстановитьТекстЗапросаДинамическогоСписка();
	УстановитьПараметрыДинамическогоСписка(Параметры);
	
	НастроитьФормуПоПараметрам();
	
	УстановитьЗаголовокФормы();
	УстановитьНадписьОтобраныНазначения();
	
	МодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, СтандартнаяОбработка, Отказ);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПереключательВариантыВыбораПриИзменении(Элемент)
	НастроитьФормуПоВариантуВыбораНазначения();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыДинамическогоСписка(Параметры)
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ОтборПоРеквизитамЗаказа", Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "МассивЗаказов", Новый Массив());
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "НаправлениеДеятельности", Неопределено);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "НазначениеДавальца", Неопределено);
	
	Если Параметры.Отбор.Свойство("Партнер") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ОтборПоРеквизитамЗаказа", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Партнер", Параметры.Отбор.Партнер);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Договор", Параметры.Отбор.Договор);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список, "НаправлениеДеятельности", Справочники.НаправленияДеятельности.ПустаяСсылка());
			
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.НаправлениеДеятельности) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ОтборПоРеквизитамЗаказа", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "НаправлениеДеятельности", Параметры.НаправлениеДеятельности);
	КонецЕсли;
	
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		"Склад",
		Параметры.Склад);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		"СкладОтправитель",
		Параметры.СкладОтправитель);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		"Номенклатура",
		Параметры.Номенклатура);
	
	Если Параметры.Свойство("Источник") 
		И ТипЗнч(Параметры.Источник) = Тип("ДокументСсылка.ПересчетТоваров") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТоварыДругогоКачества.Номенклатура КАК Номенклатура
		|ИЗ
		|	РегистрСведений.ТоварыДругогоКачества КАК ТоварыДругогоКачества
		|ГДЕ
		|	ТоварыДругогоКачества.НоменклатураБрак = &Номенклатура";
		Запрос.УстановитьПараметр("Номенклатура", Параметры.Номенклатура);
		Номенклатура = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Номенклатура");
		Номенклатура.Добавить(Параметры.Номенклатура);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
			"Номенклатура",
			Номенклатура);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		"Характеристика",
		Параметры.Характеристика);
		
	ТаблицаТоваров = Новый ТаблицаЗначений;
	ТаблицаТоваров.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаТоваров.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	
	СтрокаТовара = ТаблицаТоваров.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаТовара, Параметры);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		"ТаблицаТоваров",
		ТаблицаТоваров);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		"Подразделение",
		Параметры.Подразделение);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		"Назначение",
		Параметры.ТекущаяСтрока);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		"ЭтоРабота", ЭтоРабота);
		
	Если Параметры.Свойство("ВключатьЗаказыДавальцев") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
			"ВключатьЗаказыДавальцев",
			Параметры.ВключатьЗаказыДавальцев);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
			"ВключатьЗаказыДавальцев",
			Истина);
	КонецЕсли;
	
	Если Параметры.Свойство("ТолькоДавальцы2_2") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
			"ТолькоДавальцы2_2",
			Параметры.ТолькоДавальцы2_2);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
			"ТолькоДавальцы2_2",
			Ложь);
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ДвиженияПоСкладскимРегистрам") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		"ДвиженияПоСкладскимРегистрам",
		Параметры.Отбор.ДвиженияПоСкладскимРегистрам);
	КонецЕсли;
	
	ТолькоСкладские = Параметры.Свойство("ТолькоСкладскиеНазначения");
	
	ЕстьОтправитель = ЗначениеЗаполнено(Параметры.СкладОтправитель);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПоНаличиюУОтправителя", ЕстьОтправитель);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПоВсемСкладам",      Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПоВсейНоменклатуре", Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПоРаспоряжению",     Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Распоряжение", Распоряжение);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ТолькоСкладскиеНазначения", ТолькоСкладские);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ТолькоТолкающиеНаправления",
		Не ИспользоватьОбеспечениеСверхПотребности И ИспользоватьТолкающиеНаправления);

КонецПроцедуры


&НаСервере
Процедура УстановитьТекстЗапросаДинамическогоСписка()
	
	Если ТипЗнч(Источник) = Тип("ДокументСсылка.ПриходныйОрдерНаТовары")
		И ЗначениеЗаполнено(Распоряжение) И Параметры.Свойство("ВариантыВыбора") Тогда
		
		Список.ТекстЗапроса = ВыполнитьПодстановки(Справочники.Назначения.ТекстЗапросаНазначенийРасширенный(), Параметры.Отбор.Свойство("Партнер"));
		
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Регистратор", Источник);
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыФормированияЗапроса = Справочники.Назначения.ПараметрыФормированияЗапросаДоступныхНазначений();
	ПараметрыФормированияЗапроса.РежимВыбора = РежимВыбора;
	ПараметрыФормированияЗапроса.ВидОперации = ВидОперации;
	ПараметрыФормированияЗапроса.Источник = Источник;
	Если ЗначениеЗаполнено(ИмяОбъекта) Тогда
		ТекстЗапроса = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяОбъекта).ТекстЗапросаДоступныхНазначений(ПараметрыФормированияЗапроса);
		Список.ТекстЗапроса = ВыполнитьПодстановки(ТекстЗапроса, Параметры.Отбор.Свойство("Партнер"));
	ИначеЕсли Источник <> Неопределено Тогда
		ТекстЗапроса = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Источник).ТекстЗапросаДоступныхНазначений(ПараметрыФормированияЗапроса);
		Список.ТекстЗапроса = ВыполнитьПодстановки(ТекстЗапроса, Параметры.Отбор.Свойство("Партнер"));
	Иначе
		Список.ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Назначения.Ссылка КАК Назначение
		|ИЗ
		|	Справочник.Назначения КАК Назначения";
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Распоряжение", Распоряжение);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПоВсемРаспоряжениям", Не ЗначениеЗаполнено(Распоряжение));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Регистратор", Источник);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Ячейка", Ячейка);
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьПодстановки(ТекстЗапроса, ЕстьПодстановкаПартнера)
	
	Если ЕстьПодстановкаПартнера Тогда
		
		ПодстановкаОтборПоРеквизитамВТаблице =
		"(НЕ &ОтборПоРеквизитамЗаказа
		|	ИЛИ Таблица.Назначение.НаправлениеДеятельности = &НаправлениеДеятельности
		|		И Таблица.Назначение.Партнер = &Партнер
		|		И Таблица.Назначение.Договор = &Договор
		|		%ТипНазначения
		|	ИЛИ Таблица.Назначение.НаправлениеДеятельности = ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
		|		И Таблица.Назначение.Партнер = &Партнер
		|		И Таблица.Назначение.Договор = &Договор
		|		%ТипНазначения
		|		И Таблица.Назначение.Заказ = НЕОПРЕДЕЛЕНО
		|	ИЛИ &НаправлениеДеятельности = ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
		|		И Таблица.Назначение.Партнер = &Партнер
		|		И Таблица.Назначение.Договор = &Договор
		|		%ТипНазначения)";
		ПодстановкаОтборПоРеквизитамВТаблице = СтрЗаменить(
			ПодстановкаОтборПоРеквизитамВТаблице,
			"%ТипНазначения",
			?(ЗначениеЗаполнено(ТипНазначения),
				"И Таблица.Назначение.ТипНазначения = &ТипНазначения",
				""));
		
		ПодстановкаОтборПоРеквизитам = 
		"(НЕ &ОтборПоРеквизитамЗаказа
		|	ИЛИ Назначение.НаправлениеДеятельности = &НаправлениеДеятельности
		|		И Назначение.Партнер = &Партнер
		|		И Назначение.Договор = &Договор
		|		%ТипНазначения
		|	ИЛИ Назначение.НаправлениеДеятельности = ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
		|		И Назначение.Партнер = &Партнер
		|		И Назначение.Договор = &Договор
		|		%ТипНазначения
		|		И Назначение.Заказ = НЕОПРЕДЕЛЕНО
		|	ИЛИ &НаправлениеДеятельности = ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
		|		И Назначение.Партнер = &Партнер
		|		И Назначение.Договор = &Договор)
		|		%ТипНазначения";
		ПодстановкаОтборПоРеквизитам = СтрЗаменить(
			ПодстановкаОтборПоРеквизитам,
			"%ТипНазначения",
			?(ЗначениеЗаполнено(ТипНазначения),
				"И Назначение.ТипНазначения = &ТипНазначения",
				""));
		
	Иначе
		
		ПодстановкаОтборПоРеквизитамВТаблице = "(НЕ &ОтборПоРеквизитамЗаказа
			|	ИЛИ Таблица.Назначение.НаправлениеДеятельности = &НаправлениеДеятельности)";
		
		ПодстановкаОтборПоРеквизитам = "(НЕ &ОтборПоРеквизитамЗаказа
			|	ИЛИ Назначение.НаправлениеДеятельности = &НаправлениеДеятельности)";
			
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПодстановкаОтборПоРеквизитамВТаблице", ПодстановкаОтборПоРеквизитамВТаблице);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПодстановкаОтборПоРеквизитам", ПодстановкаОтборПоРеквизитам);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#Область НастройкаФормы

&НаСервере
Процедура НастроитьФормуПоПараметрам()
	
	ПереключательВариантыВыбора = 2; // потребности склада-получателя
	
	ИспользоватьОбеспечениеСверхПотребности = ПолучитьФункциональнуюОпцию("РазрешитьОбособлениеТоваровСверхПотребности");
	ИспользоватьТолкающиеНаправления = ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности")
		И (Не ЗначениеЗаполнено(Параметры.НаправлениеДеятельности)
			Или ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.НаправлениеДеятельности, "ВариантОбособления") <>
				Перечисления.ВариантыОбособленияПоНаправлениюДеятельности.ПоЗаказамНаправления);
	
	
	Если Параметры.РежимВыбораНазначений = "Расширенный" И (ИспользоватьОбеспечениеСверхПотребности Или ИспользоватьТолкающиеНаправления
		) Тогда
		Элементы.ПереключательВариантыВыбора.Видимость = Истина;
		Элементы.ВНаличииОтправитель.Видимость = ЗначениеЗаполнено(Параметры.СкладОтправитель);
	Иначе
		Элементы.ПереключательВариантыВыбора.Видимость = Ложь;
		Элементы.ВНаличииОтправитель.Видимость = Ложь;
	КонецЕсли;
	
	Если ИспользоватьТолкающиеНаправления Тогда
		
		ЭлементСпискаРежимов = Элементы.ПереключательВариантыВыбора.СписокВыбора.НайтиПоЗначению(4); // значение "Все обособленные заказы"
		
		Если ИспользоватьОбеспечениеСверхПотребности Тогда
			ЭлементСпискаРежимов.Представление = НСтр("ru = 'Все назначения'");
		Иначе
			ЭлементСпискаРежимов.Представление = НСтр("ru = 'По направлениям деятельности'");
		КонецЕсли;
		
	КонецЕсли;
	
	НастроитьФормуПоВариантуВыбораНазначения();
	
	// Для перемещений обособленных товаров не имеет смысла переключатель "По всем складам", так как перемещение идет на конкретный склад.
	Если ТипЗнч(Источник) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		ЭлементСпискаРежимов = Элементы.ПереключательВариантыВыбора.СписокВыбора.НайтиПоЗначению(3); // значение "По всем складам"
		Элементы.ПереключательВариантыВыбора.СписокВыбора.Удалить(ЭлементСпискаРежимов);
	ИначеЕсли Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
		ЭлементСпискаРежимов = Элементы.ПереключательВариантыВыбора.СписокВыбора.НайтиПоЗначению(3); // значение "По всем складам"
		Элементы.ПереключательВариантыВыбора.СписокВыбора.Удалить(ЭлементСпискаРежимов);
	ИначеЕсли Не ИспользоватьОбеспечениеСверхПотребности И ИспользоватьТолкающиеНаправления Тогда
		ЭлементСпискаРежимов = Элементы.ПереключательВариантыВыбора.СписокВыбора.НайтиПоЗначению(3); // значение "По всем складам"
		Элементы.ПереключательВариантыВыбора.СписокВыбора.Удалить(ЭлементСпискаРежимов);
	КонецЕсли;
	НастроитьФормуДляРабот(Параметры.Номенклатура);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоВариантуВыбораНазначения()

	ПоРаспоряжению     = ПереключательВариантыВыбора = 0 Или ПереключательВариантыВыбора = 5;
	ПоВсемСкладам      = ПереключательВариантыВыбора = 3;
	ПоВсейНоменклатуре = ПереключательВариантыВыбора = 4 Или ПереключательВариантыВыбора = 5;

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПоВсемСкладам",      ПоВсемСкладам);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПоРаспоряжению",     ПоРаспоряжению);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПоВсейНоменклатуре", ПоВсейНоменклатуре);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		"ТолькоТолкающиеНаправления", Не ИспользоватьОбеспечениеСверхПотребности И ИспользоватьТолкающиеНаправления);

	Шаблон = НСтр("ru = 'В наличии на ""%1""'");
	ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Параметры.СкладОтправитель);
	Элементы.ВНаличииОтправитель.Заголовок = ТекстЗаголовка;

	Элементы.Количество.Видимость  = Ложь;
	Элементы.Обеспечено.Видимость  = Ложь;
	Элементы.Потребность.Видимость = Ложь;
	
	Если ПереключательВариантыВыбора = 0 Тогда // назначение товара по распоряжению
		
		Элементы.Количество.Видимость = Истина;
		
	ИначеЕсли ПереключательВариантыВыбора = 5 Тогда // назначения всех товаров распоряжения
		
	ИначеЕсли ПереключательВариантыВыбора = 1 Тогда // наличие на складе-отправителе
		
	ИначеЕсли ПереключательВариантыВыбора = 2 Тогда // потребность на складе-получателе
		
		Если ЗначениеЗаполнено(Параметры.Склад) Тогда
			Шаблон = НСтр("ru = 'Потребность на ""%1""'");
			Элементы.Потребность.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Параметры.Склад);
		КонецЕсли;
		Элементы.Потребность.Видимость = Истина;
		
	ИначеЕсли ПереключательВариантыВыбора = 3 Тогда // потребность на всех складах
		
		Элементы.Потребность.Заголовок = НСтр("ru = 'Потребность на всех складах'");
		Элементы.Потребность.Видимость = Истина;
		
	ИначеЕсли ПереключательВариантыВыбора = 4 Тогда // все заказы
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуДляРабот(Номенклатура)
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		
		Если ЭтоРабота Тогда
		
			ЭлементСпискаРежимов = Элементы.ПереключательВариантыВыбора.СписокВыбора.НайтиПоЗначению(3); // значение "По всем складам"
			Если ЭлементСпискаРежимов <> Неопределено Тогда
				Элементы.ПереключательВариантыВыбора.СписокВыбора.Удалить(ЭлементСпискаРежимов);
			КонецЕсли;
			
			ЭлементСпискаРежимов = Элементы.ПереключательВариантыВыбора.СписокВыбора.НайтиПоЗначению(2); // значение "Потребности склада-получателя"
			Если ЭлементСпискаРежимов <> Неопределено Тогда
				ЭлементСпискаРежимов.Представление = НСтр("ru = 'Потребности подразделения-получателя'");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Заголовок = НСтр("ru = 'Выбор назначения'");
	Если ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		ТекстНоменклатура = СтрЗаменить(НСтр("ru = 'Номенклатура: %1'"), "%1", Параметры.Номенклатура);
		Если ЗначениеЗаполнено(Параметры.Характеристика) Тогда
			ТекстНоменклатура = ТекстНоменклатура + ", "
				+ СтрЗаменить(НСтр("ru = 'Характеристика: %1'"), "%1", Параметры.Характеристика);
		КонецЕсли;
		Заголовок = Заголовок + " (" + ТекстНоменклатура + ")";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНадписьОтобраныНазначения()
	
	НаправлениеДеятельности = Неопределено;
	Параметры.Свойство("НаправлениеДеятельности", НаправлениеДеятельности);
	
	Партнер = Неопределено;
	Параметры.Отбор.Свойство("Партнер", Партнер);
	
	Договор = Неопределено;
	Параметры.Отбор.Свойство("Договор", Договор);
	
	ЗаголовокНадписи = "";
	Если ЗначениеЗаполнено(НаправлениеДеятельности) И ЗначениеЗаполнено(Договор) Тогда
		
		СтрокаПодстановки = НСтр("ru = 'Назначения направления деятельности %1 по договору %2'");
		ЗаголовокНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаПодстановки, НаправлениеДеятельности, Договор);
		
	ИначеЕсли ЗначениеЗаполнено(НаправлениеДеятельности) И ЗначениеЗаполнено(Партнер) Тогда
		
		СтрокаПодстановки = НСтр("ru = 'Назначения направления деятельности %1 давальца %2'");
		ЗаголовокНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаПодстановки, НаправлениеДеятельности, Партнер);
		
	ИначеЕсли ЗначениеЗаполнено(НаправлениеДеятельности) Тогда
		
		СтрокаПодстановки = НСтр("ru = 'Назначения направления деятельности %1'");
		ЗаголовокНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаПодстановки, НаправлениеДеятельности);
		
	ИначеЕсли ЗначениеЗаполнено(Договор) Тогда
		
		СтрокаПодстановки = НСтр("ru = 'Назначения по договору %1'");
		ЗаголовокНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаПодстановки, Договор);
		
	ИначеЕсли ЗначениеЗаполнено(Партнер) Тогда
		
		СтрокаПодстановки = НСтр("ru = 'Назначения давальца %1'");
		ЗаголовокНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаПодстановки, Партнер);
		
	Иначе
		
		Элементы.НадписьОтобраныНазначения.Видимость = Ложь;
		
	КонецЕсли;
	Элементы.НадписьОтобраныНазначения.Заголовок = ЗаголовокНадписи;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
