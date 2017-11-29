﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
		// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	МассивОписей = Неопределено;
	Параметры.Свойство("Описи", МассивОписей);
	Если ЗначениеЗаполнено(МассивОписей) Тогда
		СписокОписей.ЗагрузитьЗначения(МассивОписей);
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	Если НЕ ЗначениеЗаполнено(Идентификатор) Тогда
		
		Элементы.ФормаКнопкаПечать.Видимость = Ложь;
		
		// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
	КонецЕсли;
	
	Параметры.Свойство("ДатаНачала",	ДатаНачала);
	Параметры.Свойство("ДатаОкончания",	ДатаОкончания);
	Если Параметры.Свойство("Склад") Тогда
		Склады.Добавить(Параметры.Склад);
	ИначеЕсли Параметры.Свойство("Склады") Тогда
		Склады.ЗагрузитьЗначения(Параметры.Склады);
	КонецЕсли;		
	
	МассивОрганизаций = Неопределено;
	Параметры.Свойство("ОтметитьОрганизации", МассивОрганизаций);
	Если ТипЗнч(МассивОрганизаций) = Тип("Массив") Тогда
		ОтметитьОрганизации.ЗагрузитьЗначения(МассивОрганизаций);
	КонецЕсли;
	
	ОбновитьДекорацияСостояниеСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияСостояниеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылка = "ОформитьСкладскиеАкты" Тогда
		ПараметрыФормы = Новый Структура;
		Если Склады.Количество() = 1 Тогда 
			ПараметрыФормы.Вставить("Склад", Склады[0].Значение);
		КонецЕсли;
		ОткрытьФорму("Обработка.ПомощникОформленияСкладскихАктов.Форма", ПараметрыФормы, ЭтаФорма);
	ИначеЕсли НавигационнаяСсылка = "СформироватьОпись" Тогда
		
		Если Склады.Количество() = 1 Тогда
			ОткрытьФормуФормированияОписей(Склады[0].Значение);
		Иначе
			ОткрытьФормуФормированияОписей();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОписи

&НаКлиенте
Процедура ОписиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		СтандартнаяОбработка = Ложь;
		ОбработатьВыбранныеСтроки();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОписиПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КнопкаПечать(Команда)
	
	Перем Отказ;
	ТекстСообщения = "";
	
	ОчиститьСообщения();
	
	Если СписокОписей.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Невозможно напечатать форму ""%ПечатнаяФорма%"", т.к. не сформировано ни одного документа ""Инвентаризационная опись"".'");
		Отказ = Истина;
	ИначеЕсли Элементы.Описи.ВыделенныеСтроки.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не выделено ни одной описи на печать. Печать формы ""%ПечатнаяФорма%"" невозможна.'");
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ = Истина Тогда
		ПечатнаяФорма = "";
		Если Идентификатор = "ИНВ3" Тогда
			ПечатнаяФорма = НСтр("ru = 'Инвентаризационная опись (ИНВ-3)'");	
		ИначеЕсли Идентификатор = "ИНВ19" Тогда 
			ПечатнаяФорма = НСтр("ru = 'Сличительная ведомость (ИНВ-19)'");
		Иначе
			ВызватьИсключение НСтр("ru = 'Неверный идентификатор печатной формы. Обратитесь к администратору.'");
		КонецЕсли;
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПечатнаяФорма%", ПечатнаяФорма);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ОбработатьВыбранныеСтроки();
	
	Закрыть();
		
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Описи);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Описи, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Описи);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Описи);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДекорацияСостояниеСервер()
	
	Описи.Отбор.Элементы.Очистить();
	ЭлементОтбора = Описи.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.ПравоеЗначение = СписокОписей;
	ЭлементОтбора.Использование = Истина;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Элементы.ДекорацияСформироватьОписьНесколькоОрганизаций.Видимость = Истина;
		Элементы.ДекорацияСформироватьОписьОднаОрганизация.Видимость	  = Ложь;
	Иначе
		Элементы.ДекорацияСформироватьОписьНесколькоОрганизаций.Видимость = Ложь;
		Элементы.ДекорацияСформироватьОписьОднаОрганизация.Видимость	  = Истина;
	КонецЕсли;
		
	МассивСкладов = Склады.ВыгрузитьЗначения();
	ТаблицаНоменклатуры = Обработки.ПомощникОформленияСкладскихАктов.ПолучитьСписокТоваровКОформлениюСкладскихАктов(МассивСкладов,, ДатаНачала, ДатаОкончания);
	Если ТаблицаНоменклатуры.Количество() = 0 Тогда
		Элементы.ДекорацияСформироватьАкты.Видимость = Ложь; 
	Иначе
		Элементы.ДекорацияСформироватьАкты.Видимость = Истина; 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуФормированияОписей(Знач Склад = Неопределено)
	
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("ДатаНачала",	ДатаНачала);
	ПараметрыФормирования.Вставить("ДатаОкончания",	ДатаОкончания);
	Если НЕ Склад = Неопределено Тогда
		ПараметрыФормирования.Вставить("Склад", 	Склад);
	КонецЕсли;
	ПараметрыФормирования.Вставить("ОтметитьОрганизации", ОтметитьОрганизации.ВыгрузитьЗначения());
	
	Оповещение = Новый ОписаниеОповещения("СформироватьОписьЗавершение", ЭтаФорма);
	ОткрытьФорму("Документ.ИнвентаризационнаяОпись.Форма.ФормаФормирование",
		ПараметрыФормирования, ЭтаФорма,, ВариантОткрытияОкна.ОтдельноеОкно,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОписьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено ИЛИ НЕ ТипЗнч(Результат) = Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Опись Из Результат Цикл
		СписокОписей.Добавить(Опись);
	КонецЦикла;
	
	ОбновитьДекорацияСостояниеСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыбранныеСтроки()
	
	Если Идентификатор = "ИНВ3" Тогда
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Обработка.ПечатьИНВ3",
			"ИНВ3",
			Элементы.Описи.ВыделенныеСтроки,
			ЭтаФорма);

	ИначеЕсли Идентификатор = "ИНВ19" Тогда
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Обработка.ПечатьИНВ19",
			"ИНВ19",
			Элементы.Описи.ВыделенныеСтроки,
			ЭтаФорма);

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
