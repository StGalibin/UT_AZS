﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаРегУчета = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(ВалютаРегУчета);
	
	ЭтоДокументПродажи         = ?(Параметры.Свойство("ЭтоДокументПродажи"),Параметры.ЭтоДокументПродажи,Ложь);
	ЭтоДокументЗакупки         = ?(Параметры.Свойство("ЭтоДокументЗакупки"),Параметры.ЭтоДокументЗакупки,Ложь);
	ДатаДокумента              = Параметры.ДатаДокумента;
	ВалютаДокумента            = Параметры.ВалютаДокумента;
	СуммаДокумента             = Параметры.СуммаДокумента;
	СуммаДокументаПриОткрытии  = Параметры.СуммаДокумента;
	ВалютаДокументаПриОткрытии = Параметры.ВалютаДокумента;
	
	ВалютаВзаиморасчетов            = Параметры.ВалютаВзаиморасчетов;
	ВалютаВзаиморасчетовПриОткрытии = Параметры.ВалютаВзаиморасчетов;
	
	ТолькоПросмотр                     = Параметры.ТолькоПросмотр;
	ВалютаДокументаТолькоПросмотр      = Параметры.Свойство("ВалютаДокументаТолькоПросмотр") 
											И Параметры.ВалютаДокументаТолькоПросмотр;
	
	ВалютаВзаиморасчетовТолькоПросмотр = Параметры.Свойство("ВалютаВзаиморасчетовТолькоПросмотр")
											И Параметры.ВалютаВзаиморасчетовТолькоПросмотр;
	
	НеПоказыватьРасчеты                = Параметры.Свойство("НеПоказыватьРасчеты") 
											И Параметры.НеПоказыватьРасчеты;
	
	НеПересчитыватьСуммуДокумента      = Параметры.Свойство("НеПересчитыватьСуммуДокумента") 
											И Параметры.НеПересчитыватьСуммуДокумента;
	
	Если ВалютаВзаиморасчетов = ВалютаДокумента И Параметры.СуммаВзаиморасчетов = 0 Тогда
		СуммаВзаиморасчетов = Параметры.СуммаДокумента;
	Иначе
		СуммаВзаиморасчетов = Параметры.СуммаВзаиморасчетов;
	КонецЕсли;
	
	Если ВалютаДокумента = ВалютаРегУчета И НЕ ВалютаВзаиморасчетов = ВалютаРегУчета Тогда
		КурсВалютыВзаиморасчетов = Параметры.Курс;
		КратностьВалютыВзаиморасчетов = Параметры.Кратность;
		КурсВалютыДокумента = 1;
		КратностьВалютыДокумента = 1;
	Иначе
		КурсВалютыДокумента = Параметры.Курс;
		КратностьВалютыДокумента = Параметры.Кратность;
		КурсВалютыВзаиморасчетов = 1;
		КратностьВалютыВзаиморасчетов = 1;
	КонецЕсли;
	
	УстановитьВидимостьЭлементов();
	
	ЗаполнитьСписокКурсовВалют();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ЗавершениеРаботы Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если Модифицированность И Не Готово Тогда
			
			Отказ = Истина;
			
			СписокКнопок = Новый СписокЗначений();
			СписокКнопок.Добавить("Закрыть", НСтр("ru = 'Закрыть'"));
			СписокКнопок.Добавить("НеЗакрывать", НСтр("ru = 'Не закрывать'"));
			
			ПоказатьВопрос(
				Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), 
				НСтр("ru = 'Все измененные данные будут потеряны. Закрыть форму?'"), 
				СписокКнопок);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = "Закрыть" Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КурсВзаиморасчетовПриИзменении(Элемент)
	ОчиститьСообщения();
	ПересчитатьСуммуВзаиморасчетов();
КонецПроцедуры

&НаКлиенте
Процедура КурсВзаиморасчетовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = 0 Тогда
		СтандартнаяОбработка = Ложь;
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("КурсВзаиморасчетовОбработкаВыбораЗавершение", ЭтотОбъект);
		ПоказатьВводДаты(ОбработчикОповещенияОЗакрытии, ДатаДокумента, НСтр("ru = 'Укажите дату курса валюты'"), ЧастиДаты.Дата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КурсВзаиморасчетовОбработкаВыбораЗавершение(ДатаКурса, ДополнительныеПараметры) Экспорт
	
	Если ДатаКурса <> Неопределено Тогда
		КурсВзаиморасчетовОбработкаВыбораНаСервере(ДатаКурса);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КурсВалютыДокументаПриИзменении(Элемент)
	ОчиститьСообщения();
	ПересчитатьСуммуВзаиморасчетов();
КонецПроцедуры

&НаКлиенте
Процедура КурсВалютыДокументаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ВыбранноеЗначение = 0 Тогда
		СтандартнаяОбработка = Ложь;
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("КурсДокументаОбработкаВыбораЗавершение", ЭтотОбъект);
		ПоказатьВводДаты(ОбработчикОповещенияОЗакрытии, ДатаДокумента, НСтр("ru = 'Укажите дату курса валюты'"), ЧастиДаты.Дата);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КурсДокументаОбработкаВыбораЗавершение(ДатаКурса, ДополнительныеПараметры) Экспорт
	
	Если ДатаКурса <> Неопределено Тогда
		КурсДокументаОбработкаВыбораНаСервере(ДатаКурса);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаВзаиморасчетовПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ВалютаВзаиморасчетов) Тогда
		ВалютаВзаиморасчетов = ВалютаВзаиморасчетовПриОткрытии;
	КонецЕсли;
	
	Если ВалютаВзаиморасчетов = ВалютаРегУчета Тогда
		КурсВалютыВзаиморасчетов = 1;
		КратностьВалютыВзаиморасчетов = 1;
	КонецЕсли;
	
	ЗаполнитьСписокКурсовВалют(Истина);
	ПересчитатьСуммуВзаиморасчетов();
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДокументаПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ВалютаДокументаПриОткрытии) ИЛИ НеПересчитыватьСуммуДокумента Тогда
		Возврат;
	КонецЕсли;
	
	Если СуммаДокумента = 0 Тогда
		
		ПересчитатьСуммуПриИзмененииВалюты(КодВозвратаДиалога.Да, Неопределено);
		
	ИначеЕсли ВалютаДокументаПриОткрытии <> ВалютаДокумента И ЗначениеЗаполнено(ВалютаДокумента) Тогда
		ТекстСообщения = НСтр("ru='Пересчитать суммы в документе в валюту ""%Валюта%""?'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Валюта%", ВалютаДокумента);
		
		Оповещение = Новый ОписаниеОповещения("ПересчитатьСуммуПриИзмененииВалюты", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		Если ВалютаДокумента = ВалютаРегУчета ИЛИ ВалютаВзаиморасчетов = ВалютаДокумента Тогда
			КурсВалютыДокумента = 1;
			КратностьВалютыДокумента = 1;
		КонецЕсли;
		
		ВалютаДокумента = ВалютаДокументаПриОткрытии;
		СуммаДокумента = СуммаДокументаПриОткрытии;
		
		ЗаполнитьСписокКурсовВалют(Истина);
		ПересчитатьСуммуВзаиморасчетов();
		УстановитьВидимостьЭлементов();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСуммуПриИзмененииВалюты(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		ПересчитатьСуммуДокумента();
		НеобходимПересчетСуммДокумента = Истина;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	Если ВалютаДокумента = ВалютаРегУчета ИЛИ ВалютаДокумента = ВалютаВзаиморасчетов Тогда
		КурсВалютыДокумента = 1;
		КратностьВалютыДокумента = 1;
	КонецЕсли;
	
	ЗаполнитьСписокКурсовВалют(Истина);
	ПересчитатьСуммуВзаиморасчетов();
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаВзаиморасчетовПриИзменении(Элемент)
	ПересчитатьКурс();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	СтруктураРеквизитовФормы = Новый Структура;
	СтруктураРеквизитовФормы.Вставить("ВалютаВзаиморасчетов", ВалютаВзаиморасчетов);
	СтруктураРеквизитовФормы.Вставить("Валюта",               ВалютаДокумента);
	
	Если НЕ ВалютаВзаиморасчетов = ВалютаРегУчета И ВалютаДокумента = ВалютаРегУчета Тогда
		СтруктураРеквизитовФормы.Вставить("Курс",      КурсВалютыВзаиморасчетов);
		СтруктураРеквизитовФормы.Вставить("Кратность", КратностьВалютыВзаиморасчетов);
	Иначе
		СтруктураРеквизитовФормы.Вставить("Курс",      КурсВалютыДокумента);
		СтруктураРеквизитовФормы.Вставить("Кратность", КратностьВалютыДокумента);
	КонецЕсли;
	
	СтруктураРеквизитовФормы.Вставить("СуммаВзаиморасчетов", СуммаВзаиморасчетов);
	СтруктураРеквизитовФормы.Вставить("НеобходимПересчетСуммДокумента", НеобходимПересчетСуммДокумента);
	
	Готово = Истина;
	
	Закрыть(СтруктураРеквизитовФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокКурсовВалют(ИзмененаВалюта=Ложь)
	
	СписокКурсовВалют = Новый СписокЗначений;
	
	Если ВалютаДокумента = ВалютаРегУчета 
		ИЛИ ВалютаВзаиморасчетов = ВалютаРегУчета Тогда
		
		Если НЕ ВалютаДокумента = ВалютаРегУчета Тогда
			КурсНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
			Если Не ЗначениеЗаполнено(КурсВалютыДокумента) ИЛИ ИзмененаВалюта Тогда
				КратностьВалютыДокумента = КурсНаДату.Кратность;
				КурсВалютыДокумента = КурсНаДату.Курс;
			КонецЕсли;
			
			СписокКурсовВалют.Добавить(КурсНаДату.Курс, Формат(КурсНаДату.Курс, "ЧДЦ=4") + " "
				+ СтрШаблон(НСтр("ru = '(на %1)'"), Формат(ДатаДокумента, "ДЛФ = D")));
				
			Для ДеньМинус = 1 По 5 Цикл
				ДатаКурса = ДатаДокумента - (ДеньМинус * 86400);
				КурсНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаКурса);
				
				СписокКурсовВалют.Добавить(КурсНаДату.Курс, Формат(КурсНаДату.Курс, "ЧДЦ=4") + " "
					+ СтрШаблон(НСтр("ru = '(на %1)'"), Формат(ДатаКурса, "ДЛФ = D")));
					
			КонецЦикла;
			СписокКурсовВалют.Добавить(0, НСтр("ru = '<Выбрать другую дату>'"));
			
			Элементы.КурсВалютыДокумента.СписокВыбора.Очистить();
			
			Для Каждого КурсНаДату Из СписокКурсовВалют Цикл
				Элементы.КурсВалютыДокумента.СписокВыбора.Добавить(КурсНаДату.Значение, КурсНаДату.Представление);
			КонецЦикла;
		Иначе
			КурсНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, ДатаДокумента);
			Если Не ЗначениеЗаполнено(КурсВалютыВзаиморасчетов) ИЛИ ИзмененаВалюта Тогда
				КратностьВалютыВзаиморасчетов = КурсНаДату.Кратность;
				КурсВалютыВзаиморасчетов = КурсНаДату.Курс;
			КонецЕсли;
			
			СписокКурсовВалют.Добавить(КурсНаДату.Курс, Формат(КурсНаДату.Курс, "ЧДЦ=4") + " "
				+ СтрШаблон(НСтр("ru = '(на %1)'"), Формат(ДатаДокумента, "ДЛФ = D")));
				
			Для ДеньМинус = 1 По 5 Цикл
				ДатаКурса = ДатаДокумента - (ДеньМинус * 86400);
				КурсНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, ДатаКурса);
				
				СписокКурсовВалют.Добавить(КурсНаДату.Курс, Формат(КурсНаДату.Курс, "ЧДЦ=4") + " "
					+ СтрШаблон(НСтр("ru = '(на %1)'"), Формат(ДатаКурса, "ДЛФ = D")));
					
			КонецЦикла;
			СписокКурсовВалют.Добавить(0, НСтр("ru = '<Выбрать другую дату>'"));
			
			Элементы.КурсВалютыВзаиморасчетов.СписокВыбора.Очистить();
			
			Для Каждого КурсНаДату Из СписокКурсовВалют Цикл
				Элементы.КурсВалютыВзаиморасчетов.СписокВыбора.Добавить(КурсНаДату.Значение, КурсНаДату.Представление);
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ВалютаДокумента) И ЗначениеЗаполнено(ВалютаВзаиморасчетов) Тогда
		
		КурсВалютыДокументаНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
		КурсВалютыВазиморасчетовНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, ДатаДокумента);
		
		КурсПересчета = РаботаСКурсамиВалютУТ.ПолучитьКроссКурсВалют(КурсВалютыДокументаНаДату,КурсВалютыВазиморасчетовНаДату);
		Если Не ЗначениеЗаполнено(КурсВалютыДокумента) ИЛИ ИзмененаВалюта Тогда
			КратностьВалютыДокумента = КурсПересчета.Кратность;
			КурсВалютыДокумента = КурсПересчета.Курс;
		КонецЕсли;
		СписокКурсовВалют.Добавить(Окр(КурсПересчета.Курс,4), Формат(КурсПересчета.Курс, "ЧДЦ=4") + " " + СтрШаблон(НСтр("ru = '(на %1)'"), Формат(ДатаДокумента, "ДЛФ = D")));
		Для ДеньМинус = 1 По 5 Цикл
			ДатаКурса = ДатаДокумента - (ДеньМинус * 86400);
			КурсВалютыДокументаНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаКурса);
			КурсВалютыВазиморасчетовНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, ДатаКурса);
			КурсПересчета = РаботаСКурсамиВалютУТ.ПолучитьКроссКурсВалют(КурсВалютыДокументаНаДату,КурсВалютыВазиморасчетовНаДату);
			СписокКурсовВалют.Добавить(Окр(КурсПересчета.Курс,4), Формат(КурсПересчета.Курс, "ЧДЦ=4") + " " + СтрШаблон(НСтр("ru = '(на %1)'"), Формат(ДатаКурса, "ДЛФ = D")));
		КонецЦикла;
		СписокКурсовВалют.Добавить(0, НСтр("ru = '<Выбрать другую дату>'"));
		
		Элементы.КурсВалютыДокумента.СписокВыбора.Очистить();
		
		Для Каждого КурсНаДату Из СписокКурсовВалют Цикл
			Элементы.КурсВалютыДокумента.СписокВыбора.Добавить(КурсНаДату.Значение, КурсНаДату.Представление);
		КонецЦикла;
		
	КонецЕсли;
	
	Если Элементы.КурсВалютыДокумента.СписокВыбора.Количество()>0 
			И Элементы.КурсВалютыДокумента.СписокВыбора.НайтиПоЗначению(КурсВалютыДокумента) = Неопределено 
			И ЗначениеЗаполнено(КурсВалютыДокумента) Тогда
		Элементы.КурсВалютыДокумента.СписокВыбора.Добавить(КурсВалютыДокумента);
	КонецЕсли;
	
	Если Элементы.КурсВалютыВзаиморасчетов.СписокВыбора.Количество()>0 
			И Элементы.КурсВалютыВзаиморасчетов.СписокВыбора.НайтиПоЗначению(КурсВалютыВзаиморасчетов) = Неопределено 
			И ЗначениеЗаполнено(КурсВалютыВзаиморасчетов) Тогда
		Элементы.КурсВалютыВзаиморасчетов.СписокВыбора.Добавить(КурсВалютыВзаиморасчетов);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КурсВзаиморасчетовОбработкаВыбораНаСервере(ДатаКурса)
	
	Если НЕ ДатаКурса > ТекущаяДатаСеанса() Тогда
		ТекстНаДату = " " + СтрШаблон(НСтр("ru = '(на %1)'"), Формат(ДатаКурса, "ДЛФ = D"));
	Иначе
		ТекстНаДату = "";
	КонецЕсли;
	
	КурсНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, ДатаКурса);
	КурсВалютыВзаиморасчетов = КурсНаДату.Курс;
	КратностьВалютыВзаиморасчетов = КурсНаДату.Кратность;
	
	Если Элементы.КурсВалютыВзаиморасчетов.СписокВыбора.НайтиПоЗначению(КурсВалютыВзаиморасчетов) = Неопределено Тогда
		Элементы.КурсВалютыВзаиморасчетов.СписокВыбора.Добавить(КурсНаДату.Курс, Формат(КурсНаДату.Курс, "ЧДЦ=4") + ТекстНаДату);
	КонецЕсли;
	
	ПересчитатьСуммуВзаиморасчетов();
	
КонецПроцедуры

&НаСервере
Процедура КурсДокументаОбработкаВыбораНаСервере(ДатаКурса)
	
	Если НЕ ДатаКурса > ТекущаяДатаСеанса() Тогда
		ТекстНаДату = " " + СтрШаблон(НСтр("ru = '(на %1)'"), Формат(ДатаКурса, "ДЛФ = D"));
	Иначе
		ТекстНаДату = "";
	КонецЕсли;
	
	Если ВалютаВзаиморасчетов = ВалютаРегУчета Тогда
	
		КурсНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаКурса);
		КурсВалютыДокумента = КурсНаДату.Курс;
		КратностьВалютыДокумента = КурсНаДату.Кратность;
		
		Если Элементы.КурсВалютыДокумента.СписокВыбора.НайтиПоЗначению(КурсВалютыДокумента) = Неопределено Тогда
			Элементы.КурсВалютыДокумента.СписокВыбора.Добавить(КурсНаДату.Курс,
																Формат(КурсНаДату.Курс, "ЧДЦ=4") + ТекстНаДату);
		КонецЕсли;
		
	Иначе
		
		КурсВалютыДокументаНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаКурса);
		КурсВалютыВазиморасчетовНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, ДатаКурса);
		
		КурсПересчета = РаботаСКурсамиВалютУТ.ПолучитьКроссКурсВалют(КурсВалютыДокументаНаДату,КурсВалютыВазиморасчетовНаДату);
		
		КратностьВалютыДокумента = КурсПересчета.Кратность;
		КурсВалютыДокумента = КурсПересчета.Курс;
		
		Если Элементы.КурсВалютыДокумента.СписокВыбора.НайтиПоЗначению(КратностьВалютыДокумента) = Неопределено Тогда
			Элементы.КурсВалютыДокумента.СписокВыбора.Добавить(Окр(КурсПересчета.Курс,4),
																Формат(КурсПересчета.Курс, "ЧДЦ=4") + ТекстНаДату);
		КонецЕсли;
		
	КонецЕсли;
	
	ПересчитатьСуммуВзаиморасчетов();
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьСуммуДокумента()
	
	Если СуммаДокументаПриОткрытии > 0 Тогда
		СуммаДокумента = РаботаСКурсамиВалют.ПересчитатьВВалюту(СуммаДокументаПриОткрытии,
							ВалютаДокументаПриОткрытии, ВалютаДокумента, ДатаДокумента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьСуммуВзаиморасчетов()
	
	Если СуммаДокумента <> 0 И ЗначениеЗаполнено(ВалютаВзаиморасчетов) Тогда
		Если ВалютаВзаиморасчетов = ВалютаРегУчета ИЛИ ВалютаДокумента = ВалютаРегУчета Тогда
			
			ПараметрыВалютыДок = Новый Структура("Валюта, Курс, Кратность",
				ВалютаДокумента, КурсВалютыДокумента, КратностьВалютыДокумента);
			ПараметрыВалютыВР  = Новый Структура("Валюта, Курс, Кратность",
				ВалютаВзаиморасчетов, КурсВалютыВзаиморасчетов, КратностьВалютыВзаиморасчетов);
			
			СуммаВзаиморасчетов = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(СуммаДокумента,
				ПараметрыВалютыДок,ПараметрыВалютыВР);
			
		Иначе
			
			СуммаВзаиморасчетов = СуммаДокумента*КурсВалютыДокумента/КратностьВалютыДокумента;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьКурс()
	
	Если НЕ ЗначениеЗаполнено(ВалютаДокумента) Тогда
		КурсВалютыДокумента = 1;
	ИначеЕсли НЕ ВалютаДокумента = ВалютаРегУчета И ВалютаВзаиморасчетов = ВалютаРегУчета Тогда
		КурсВалютыДокумента = СуммаВзаиморасчетов/СуммаДокумента/КратностьВалютыВзаиморасчетов;
	ИначеЕсли НЕ ВалютаВзаиморасчетов = ВалютаРегУчета И ВалютаДокумента = ВалютаРегУчета Тогда
		КурсВалютыВзаиморасчетов = ?(СуммаВзаиморасчетов=0,0,СуммаДокумента*КратностьВалютыВзаиморасчетов/СуммаВзаиморасчетов);
	Иначе
		КурсВалютыДокумента = СуммаВзаиморасчетов*КратностьВалютыДокумента/СуммаДокумента/КратностьВалютыВзаиморасчетов;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КратностьВзаиморасчетовПриИзменении(Элемент)
	ПересчитатьСуммуВзаиморасчетов();
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	ОбеВалютыЗаполнены = ЗначениеЗаполнено(ВалютаВзаиморасчетов) И ЗначениеЗаполнено(ВалютаДокумента);
	
	ВидимостьКурсаВзаиморасчетов = (ВалютаВзаиморасчетов <> ВалютаРегУчета 
									И ВалютаДокумента = ВалютаРегУчета 
									И ОбеВалютыЗаполнены И НЕ НеПоказыватьРасчеты);
	
	Элементы.КурсВалютыВзаиморасчетов.Видимость      = ВидимостьКурсаВзаиморасчетов;
	Элементы.КратностьВалютыВзаиморасчетов.Видимость = ВидимостьКурсаВзаиморасчетов;
	Элементы.ЗаголовокКурсВзаиморасчетов.Видимость   = ВидимостьКурсаВзаиморасчетов;
	
	ВидимостьКурсаДокумента = (ВалютаДокумента <> ВалютаРегУчета 
								И ВалютаВзаиморасчетов <> ВалютаДокумента 
								И ОбеВалютыЗаполнены И НЕ НеПоказыватьРасчеты);
	
	Элементы.КурсВалютыДокумента.Видимость      = ВидимостьКурсаДокумента;
	Элементы.КратностьВалютыДокумента.Видимость = ВидимостьКурсаДокумента;
	Элементы.ЗаголовокКурсДокумента.Видимость   = ВидимостьКурсаДокумента;
	
	Элементы.ПолеСуммаДокумента.Видимость           = СуммаДокумента <> 0;
	Элементы.СуммаВзаиморасчетов.Видимость          = НЕ НеПоказыватьРасчеты И СуммаДокумента <> 0;
	Элементы.ЗаголовокСуммаВзаиморасчетов.Видимость = НЕ НеПоказыватьРасчеты;
	Элементы.ВалютаВзаиморасчетов.Видимость         = НЕ НеПоказыватьРасчеты;
	
	Если ЭтоДокументПродажи И НЕ Пользователи.РолиДоступны("ИзменениеКурсаВДокументахПродажи") 
		ИЛИ ЭтоДокументЗакупки И НЕ Пользователи.РолиДоступны("ИзменениеКурсаВДокументахЗакупки") Тогда
		
		ТолькоПросмотр = Истина;
		
	Иначе
		
		Элементы.СуммаВзаиморасчетов.Доступность = ВалютаДокумента <> ВалютаВзаиморасчетов 
													И СуммаДокумента <> 0 И НЕ ТолькоПросмотр;
		
		ВидимостьВалютаКВалюте = ВалютаВзаиморасчетов <> ВалютаРегУчета 
									И ВалютаДокумента <> ВалютаРегУчета 
									И ВалютаДокумента <> ВалютаВзаиморасчетов И ОбеВалютыЗаполнены;
		
		Элементы.НадписьВалютаКВалюте.Видимость = ВидимостьВалютаКВалюте;
		
		Если ВидимостьВалютаКВалюте Тогда
			Элементы.НадписьВалютаКВалюте.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
														"(%1 /%2 %3)",
														ВалютаВзаиморасчетов,
														?(КратностьВалютыДокумента = 1, "", " " + Строка(КратностьВалютыДокумента)),
														ВалютаДокумента);
		КонецЕсли;
		
		Элементы.ВалютаДокумента.ТолькоПросмотр               = ВалютаДокументаТолькоПросмотр ИЛИ ТолькоПросмотр;
		Элементы.ВалютаВзаиморасчетов.ТолькоПросмотр          = ВалютаВзаиморасчетовТолькоПросмотр ИЛИ ТолькоПросмотр;
		Элементы.КурсВалютыВзаиморасчетов.ТолькоПросмотр      = ТолькоПросмотр;
		Элементы.КратностьВалютыВзаиморасчетов.ТолькоПросмотр = ТолькоПросмотр;
		Элементы.КурсВалютыДокумента.ТолькоПросмотр           = ТолькоПросмотр;
		Элементы.КратностьВалютыДокумента.ТолькоПросмотр      = ТолькоПросмотр;
		
	КонецЕсли;
	
	Элементы.ФормаПеренестиВДокумент.Доступность = НЕ ТолькоПросмотр;
	
КонецПроцедуры

#КонецОбласти

