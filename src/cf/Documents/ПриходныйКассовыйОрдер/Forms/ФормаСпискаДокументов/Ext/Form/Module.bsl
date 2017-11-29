﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	
	ИнициализироватьРеквизиты();
	
	ОписаниеОтборов = Новый Соответствие;
	ОписаниеОтборов.Вставить("Организация", Тип("СправочникСсылка.Организации"));
	ОписаниеОтборов.Вставить("Касса", Тип("СправочникСсылка.Кассы"));
	УправлениеДоступом.НастроитьОтборыДинамическогоСписка(ПриходныеКассовыеОрдера, ОписаниеОтборов);
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		РазрешенныеОрганизации = УправлениеДоступом.РазрешенныеЗначенияДляДинамическогоСписка("РегистрСведений.ГрафикПлатежей", Тип("СправочникСсылка.Организации"));
		Если РазрешенныеОрганизации <> Неопределено Тогда
			РаспоряженияНаПоступление.Параметры.УстановитьЗначениеПараметра("РазрешенныеЗначенияПоляОрганизация", РазрешенныеОрганизации);
		КонецЕсли;
		РазрешенныеКассы = УправлениеДоступом.РазрешенныеЗначенияДляДинамическогоСписка("РегистрСведений.ГрафикПлатежей", Тип("СправочникСсылка.Кассы"));
		Если РазрешенныеКассы <> Неопределено Тогда
			РазрешенныеКассы.Добавить(Неопределено);
			РаспоряженияНаПоступление.Параметры.УстановитьЗначениеПараметра("РазрешенныеЗначенияПоляКасса", РазрешенныеКассы);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьОтборДинамическихСписков();
	УправлениеЭлементамиФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(ПриходныеКассовыеОрдера);
	
	Если Не ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.ЕстьОшибкиПроверкиКонтрагентов.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "ПриходныеКассовыеОрдера.Дата", "Дата");
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "РаспоряженияНаПоступление.Дата", "Дата");
	
	СохранитьРабочиеЗначенияПолейФормы(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// МеханизмВнешнегоОборудования
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтотОбъект, "СканерШтрихкода");
	// Конец МеханизмВнешнегоОборудования
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	// МеханизмВнешнегоОборудования
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтотОбъект);
	// Конец МеханизмВнешнегоОборудования
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
		И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			//Преобразуем предварительно к ожидаемому формату
			Если Параметр[1] = Неопределено Тогда
				ОбработатьШтрихкоды(Новый ОписаниеОповещения("ОбработкаОповещенияПослеОбработки", ЭтотОбъект, Новый Структура("ИмяСобытия, Параметр", ИмяСобытия, Параметр)), Новый Структура("Штрихкод, Количество", Параметр[0], 1));
                Возврат;
			Иначе
				ОбработатьШтрихкоды(Новый ОписаниеОповещения("ОбработкаОповещенияЗавершение", ЭтотОбъект, Новый Структура("ИмяСобытия", ИмяСобытия)), Новый Структура("Штрихкод, Количество", Параметр[1][1], 1));
                Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	ОбработкаОповещенияФрагмент(ИмяСобытия);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияПослеОбработки(Результат, ДополнительныеПараметры) Экспорт
    
    ИмяСобытия = ДополнительныеПараметры.ИмяСобытия;
    Параметр = ДополнительныеПараметры.Параметр;
    
    
    // Достаем штрихкод из основных данных;
    
    ОбработкаОповещенияФрагмент(ИмяСобытия);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ИмяСобытия = ДополнительныеПараметры.ИмяСобытия;
    
    
    // Достаем штрихкод из дополнительных данных;
    
    ОбработкаОповещенияФрагмент(ИмяСобытия);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияФрагмент(Знач ИмяСобытия)
	
	Если ИмяСобытия = "Запись_ПриходныйКассовыйОрдер" Тогда
		ОбновитьДиначескиеСписки();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Организация                 = Настройки.Получить("Организация");
	Касса                       = Настройки.Получить("Касса");
	
	СписокОпераций              = Настройки.Получить("СписокОперацийПоступления");
	ИнициализироватьСписокОперацийПоступления();
	Если СписокОпераций <> Неопределено Тогда
		Для каждого Операция Из СписокОпераций Цикл
			Если Операция.Пометка Тогда
				ОперацияСписка = СписокОперацийПоступления.НайтиПоЗначению(Операция.Значение);
				Если ОперацияСписка <> Неопределено Тогда
					ОперацияСписка.Пометка = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	ХозяйственнаяОперацияПредставление = СписокОперацийПредставление(СписокОперацийПоступления);
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КассаОтборПриИзменении(Элемент)
	
	КассаОтборПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспоряженияНаПоступлениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Ссылка = Элементы.РаспоряженияНаПоступление.ТекущиеДанные.Ссылка;
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ПоказатьЗначение(Неопределено, Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьДиначескиеСписки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаКПоступлениюПриИзменении(Элемент)
	
	ДатаКПоступлениюПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ДатаКПоступлениюПриИзмененииНаСервере()
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПредставлениеОтборОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		
		СписокОперацийПоступления = ВыбранноеЗначение;
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("ПеречислениеСсылка.ОбластиПланированияПлатежей") Тогда
		
		Для Каждого ЭлементСписка Из СписокОперацийПоступления Цикл
			ЭлементСписка.Пометка = (ЭлементСписка.Значение = ВыбранноеЗначение);
		КонецЦикла;
	КонецЕсли;
	
	ХозяйственнаяОперацияПредставление = СписокОперацийПредставление(СписокОперацийПоступления);
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПредставлениеОтборНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("Перечисление.ХозяйственныеОперации.Форма.ФормаВыбораОперации",
		Новый Структура("СписокОпераций, Заголовок", СписокОперацийПоступления, НСтр("ru = 'Основания платежа'")), Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПредставлениеОтборОчистка(Элемент, СтандартнаяОбработка)
	
	СписокОперацийПоступления.ЗаполнитьПометки(Ложь);
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПлательщикПредставлениеОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		РаспоряженияНаПоступление,
		"ПлательщикПредставление",
		ПлательщикПредставление,
		ВидСравненияКомпоновкиДанных.Содержит,
		,
		ЗначениеЗаполнено(ПлательщикПредставление));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ПриходныеКассовыеОрдера,
		"ПлательщикПредставление",
		ПлательщикПредставление,
		ВидСравненияКомпоновкиДанных.Содержит,
		,
		ЗначениеЗаполнено(ПлательщикПредставление));
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПриходныеКассовыеОрдера

&НаКлиенте
Процедура ПриходныеКассовыеОрдераПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриходныеКассовыеОрдераПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не Копирование Тогда
		Отказ = Истина;
		СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьВозвратДенежныхСредствОтПоставщика(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеДенежныхСредствИзКассыККМ(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеДенежныхСредствИзБанка(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИнкассациюДенежныхСредствИзБанка(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ИнкассацияДенежныхСредствИзБанка"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеДенежныхСредствИзДругойКассы(Команда)

	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы"));

КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратДенежныхСредствОтПодотчетника(Команда)

	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтПодотчетника"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеДенежныхСредствИзДругойОрганизации(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратДенежныхСредствОтДругойОрганизации(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтДругойОрганизации"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрочееПоступлениеДенежныхСредств(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочееПоступлениеДенежныхСредств"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВнутреннююПередачуДенежныхСредств(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКонвертацияВалюты(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.КонвертацияВалюты"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеПоКредитам(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоКредитам"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПогашениеЗаймаКонтрагентом(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоЗаймамВыданным"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПогашениеЗаймаСотрудником(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПогашениеЗаймаСотрудником"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПриходныйКассовыйОрдерПоРаспоряжению(Команда)
	
	ДенежныеСредстваКлиент.ОплатитьСтрокиГрафика(Элементы.РаспоряженияНаПоступление, "ПриходныйКассовыйОрдер");
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.ПриходныеКассовыеОрдера);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.ПриходныеКассовыеОрдера, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.ПриходныеКассовыеОрдера);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.ПриходныеКассовыеОрдера);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура КассаОтборПриИзмененииНаСервере()
	
	Организация = Справочники.Кассы.ПолучитьРеквизитыКассы(Касса).Организация;
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПриходныйКассовыйОрдер.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.СчетНаОплатуКлиенту.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаказКлиента.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Знач Оповещение, Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") Тогда
			Элементы.ПриходныеКассовыеОрдера.ТекущаяСтрока = Ссылка;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаПриходныеКассовыеОрдера;
		КонецЕсли;
		
		ПоказатьЗначение(Новый ОписаниеОповещения("ОбработатьШтрихкодыЗавершение", ЭтотОбъект, Новый Структура("Данные, Оповещение", Данные, Оповещение)), Ссылка);
        Возврат;
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
	ОбработатьШтрихкодыФрагмент(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкодыЗавершение(ДополнительныеПараметры) Экспорт
    
    Данные = ДополнительныеПараметры.Данные;
    Оповещение = ДополнительныеПараметры.Оповещение;
    
    
    ОбработатьШтрихкодыФрагмент(Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкодыФрагмент(Знач Оповещение)
    
    ВыполнитьОбработкуОповещения(Оповещение);

КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РаспоряженияНаПоступлениеДатаПлатежа.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РаспоряженияНаПоступление.ДатаПлатежа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = НачалоДня(ТекущаяДатаСеанса());
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Элементы.КассаОтбор.Видимость = ИспользоватьНесколькоКасс;
	Элементы.ПриходныеКассовыеОрдераСоздатьПоступлениеДенежныхСредствИзДругойКассы.Видимость =
		ИспользоватьНесколькоКасс Или ИспользоватьРозничныеПродажи;
		
	Элементы.ПриходныеКассовыеОрдераСоздатьПогашениеЗаймаСотрудником.Видимость = Ложь;
	
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеДокументов

&НаКлиенте
Процедура СоздатьПриходныйКассовыйОрдер(ХозяйственнаяОперация)
	
	СтруктураОснования = Новый Структура;
	СтруктураОснования.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперация);
	Если ЗначениеЗаполнено(Касса) Тогда
		СтруктураОснования.Вставить("Касса", Касса);
	КонецЕсли;
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", СтруктураОснования);
	ОткрытьФорму("Документ.ПриходныйКассовыйОрдер.ФормаОбъекта", СтруктураПараметры, Элементы.ПриходныеКассовыеОрдера);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ИнициализироватьРеквизиты()
	
	ИспользоватьНесколькоКасс = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	ИспользоватьРозничныеПродажи = ПолучитьФункциональнуюОпцию("ИспользоватьРозничныеПродажи");
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РаспоряженияНаПоступлениеКонтрагент", "Видимость", Ложь);
	КонецЕсли;
	ИспользоватьДоверенности = ПолучитьФункциональнуюОпцию("ИспользоватьДоверенностиНаПолучениеТМЦ");
	ИспользоватьЗаявкиНаРасходованиеДенежныхСредств = ПолучитьФункциональнуюОпцию("ИспользоватьЗаявкиНаРасходованиеДенежныхСредств");
	ИспользоватьСчетаНаОплату = ПолучитьФункциональнуюОпцию("ИспользоватьСчетаНаОплатуКлиентам");
	
	ИнициализироватьСписокОперацийПоступления();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьРабочиеЗначенияПолейФормы(СохранитьНеопределено = Ложь)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущаяОрганизация", "", ?(СохранитьНеопределено, Неопределено, Организация));
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущаяКасса", "", ?(СохранитьНеопределено, Неопределено, Касса));
	
КонецПроцедуры

&НаСервере
Функция МассивДинамическихСписков()

	МассивСписков = Новый Массив;
	МассивСписков.Добавить(ПриходныеКассовыеОрдера);
	МассивСписков.Добавить(РаспоряженияНаПоступление);
	
	Возврат МассивСписков;

КонецФункции

&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	СписокОрганизаций = Новый СписокЗначений;
	СписокОрганизаций.Добавить(Организация);
	
	Если ЗначениеЗаполнено(Организация)
		И ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс") Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ОбособленноеПодразделение
		|	И Организации.ГоловнаяОрганизация = &Организация
		|	И Организации.ДопускаютсяВзаиморасчетыЧерезГоловнуюОрганизацию");
		Запрос.УстановитьПараметр("Организация", Организация);
		
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокОрганизаций.Добавить(Выборка.Ссылка);
		КонецЦикла;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	СписокКасс = Новый СписокЗначений;
	СписокКасс.Добавить(Справочники.Кассы.ПустаяСсылка());
	Если ЗначениеЗаполнено(Касса) Тогда
		СписокКасс.Добавить(Касса);
	КонецЕсли;
	
	Для Каждого ДинамическийСписок Из МассивДинамическихСписков() Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ДинамическийСписок,
			"Касса",
			СписокКасс,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			ЗначениеЗаполнено(Касса));
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ДинамическийСписок,
			"Организация",
			СписокОрганизаций,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			ЗначениеЗаполнено(Организация));
	КонецЦикла;
	
	Граница = ?(ЗначениеЗаполнено(ДатаКПоступлению), КонецДня(ДатаКПоступлению), Дата('39990101'));
	РаспоряженияНаПоступление.Параметры.УстановитьЗначениеПараметра("ДатаПлатежа", Граница);
	
	ОбластиПланирования = Новый Массив;
	Для каждого ЭлементСписка Из СписокОперацийПоступления Цикл
		Если ЭлементСписка.Пометка Тогда
			ОбластиПланирования.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		РаспоряженияНаПоступление,
		"ОбластьПланирования",
		ОбластиПланирования,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		ОбластиПланирования.Количество());
	
	СохранитьРабочиеЗначенияПолейФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДиначескиеСписки()
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРаспоряженияНаПоступление Тогда
		Элементы.РаспоряженияНаПоступление.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьСписокОперацийПоступления()
	
	СписокОперацийПоступления.Очистить();
	СписокОперацийПоступления.Добавить(Перечисления.ОбластиПланированияПлатежей.РасчетыСКлиентами);
	СписокОперацийПоступления.Добавить(Перечисления.ОбластиПланированияПлатежей.ВозвратыОтПоставщиков);
	СписокОперацийПоступления.Добавить(Перечисления.ОбластиПланированияПлатежей.ДенежныеСредстваВПути);
	
	Элементы.ХозяйственнаяОперацияПредставлениеОтбор.СписокВыбора.Очистить();
	Для каждого Операция Из СписокОперацийПоступления Цикл
		Элементы.ХозяйственнаяОперацияПредставлениеОтбор.СписокВыбора.Добавить(Операция.Значение, Операция.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокОперацийПредставление(СписокОпераций)
	
	СписокОперацийПредставление = "";
	Для Каждого ЭлементСписка Из СписокОпераций Цикл
		Если ЭлементСписка.Пометка Тогда
			СписокОперацийПредставление = СписокОперацийПредставление
				+ ?(ЗначениеЗаполнено(СписокОперацийПредставление), ", ", "")
				+ ?(ЗначениеЗаполнено(ЭлементСписка.Представление), ЭлементСписка.Представление, ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СписокОперацийПредставление;
	
КонецФункции

#КонецОбласти

#КонецОбласти
