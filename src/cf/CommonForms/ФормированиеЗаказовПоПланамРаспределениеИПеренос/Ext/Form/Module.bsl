﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Сценарий = Параметры.Сценарий;
	ТипПланирования = Параметры.ТипПланирования;
	Если ТипПланирования = "ПланированиеПроизводства" Тогда
		ДатаПоступления = Параметры.ДатаВыпуска;
	ИначеЕсли ТипПланирования = "ПланированиеЗакупок" Тогда
		ДатаПоступления = Параметры.ДатаПоступления;
	ИначеЕсли ТипПланирования = "ПланированиеСборкиРазборки" Тогда
		ДатаПоступления = Параметры.НачалоПериодаСборки;
	ИначеЕсли ТипПланирования = "ПланированиеПередачиМатериаловВПроизводство" Тогда
		ДатаПоступления = Параметры.НачалоПериодаПотребности;
	КонецЕсли;
	
	Если ТипПланирования = "ПланированиеПроизводства" Тогда
		Элементы.Периодичность.Заголовок = НСтр("ru = 'Периодичность планов производства'");
		Элементы.Операция.СписокВыбора[0].Представление = НСтр("ru = 'Перенести дату выпуска'");
		Элементы.ГруппаРаспределение.Заголовок = НСтр("ru = 'Распределить даты выпуска'");
		Элементы.ДеньНеделиРаспределение.Заголовок = НСтр("ru = 'Выпуск в'");
	ИначеЕсли ТипПланирования = "ПланированиеСборкиРазборки" Тогда
		Элементы.Периодичность.Заголовок = НСтр("ru = 'Периодичность планов сборки (разборки)'");
		Элементы.Операция.СписокВыбора[0].Представление = НСтр("ru = 'Перенести дату начала сбокри (разборки)'");
		Элементы.ГруппаРаспределение.Заголовок = НСтр("ru = 'Распределить даты сборки (разборки)'");
		Элементы.ДеньНеделиРаспределение.Заголовок = НСтр("ru = 'Сборка (разбока) в'");
	ИначеЕсли ТипПланирования = "ПланированиеПередачиМатериаловВПроизводство" Тогда
		Элементы.Периодичность.Заголовок = НСтр("ru = 'Периодичность планов производства'");
		Элементы.Операция.СписокВыбора[0].Представление = НСтр("ru = 'Перенести дату отгрузки материалов'");
		Элементы.ГруппаРаспределение.Заголовок = НСтр("ru = 'Распределить даты отгрузки материалов'");
		Элементы.ДеньНеделиРаспределение.Заголовок = НСтр("ru = 'Передача материалов в'");
	КонецЕсли;
	
	Периодичность = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сценарий, "Периодичность");
	
	Если НЕ ЗначениеЗаполнено(ДатаПоступления) Тогда
	
		ДатаПоступления = ТекущаяДатаСеанса();
	
	КонецЕсли;
	
	ДатаПоступления = ПланированиеКлиентСервер.РассчитатьДатуНачалаПериода(ДатаПоступления, Периодичность);
	
	Операция = "Перенос";
	
	ВариантПереноса = "НаЧисло";
	НомерДня = 1;
	
	ДобавлятьВариантПолугодия = Ложь;
	ДобавлятьВариантКвартала = Ложь;
	ДобавлятьВариантМесяца = Ложь;
	ДобавлятьВариантДекады = Ложь;
	ДобавлятьВариантНедели = Ложь;
	
	Если Периодичность = Перечисления.Периодичность.Год Тогда
		Элементы.ВариантПереноса.СписокВыбора[0].Представление = НСтр("ru = 'На день года'");
		Элементы.НомерДня.МаксимальноеЗначение = 365;
		Элементы.КоличествоПериодов.МаксимальноеЗначение = 365;
		
		ДобавлятьВариантПолугодия = Истина;
		ДобавлятьВариантКвартала = Истина;
		ДобавлятьВариантМесяца = Истина;
		ДобавлятьВариантДекады = Истина;
		ДобавлятьВариантНедели = Истина;
		
	ИначеЕсли Периодичность = Перечисления.Периодичность.Полугодие Тогда
		Элементы.ВариантПереноса.СписокВыбора[0].Представление = НСтр("ru = 'На день полугодия'");
		Элементы.НомерДня.МаксимальноеЗначение = 182;
		Элементы.КоличествоПериодов.МаксимальноеЗначение = 182;
		
		ДобавлятьВариантКвартала = Истина;
		ДобавлятьВариантМесяца = Истина;
		ДобавлятьВариантДекады = Истина;
		ДобавлятьВариантНедели = Истина;
		
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		Элементы.ВариантПереноса.СписокВыбора[0].Представление = НСтр("ru = 'На день квартала'");
		Элементы.НомерДня.МаксимальноеЗначение = 90;
		Элементы.КоличествоПериодов.МаксимальноеЗначение = 90;
		
		ДобавлятьВариантМесяца = Истина;
		ДобавлятьВариантДекады = Истина;
		ДобавлятьВариантНедели = Истина;
		
	ИначеЕсли Периодичность = Перечисления.Периодичность.Месяц Тогда
		Элементы.ВариантПереноса.СписокВыбора[0].Представление = НСтр("ru = 'На число месяца'");
		Элементы.НомерДня.МаксимальноеЗначение = 31;
		Элементы.КоличествоПериодов.МаксимальноеЗначение = 31;
		
		ДобавлятьВариантДекады = Истина;
		ДобавлятьВариантНедели = Истина;
		
	ИначеЕсли Периодичность = Перечисления.Периодичность.Декада Тогда
		Элементы.ВариантПереноса.СписокВыбора[0].Представление = НСтр("ru = 'На день в декаде'");
		Элементы.НомерДня.МаксимальноеЗначение = 10;
		Элементы.КоличествоПериодов.МаксимальноеЗначение = 10;
	ИначеЕсли Периодичность = Перечисления.Периодичность.Неделя Тогда
		Элементы.ВариантПереноса.СписокВыбора[0].Представление = НСтр("ru = 'На день недели'");
		Элементы.НомерДня.МаксимальноеЗначение = 7;
		Элементы.КоличествоПериодов.МаксимальноеЗначение = 7;
	КонецЕсли; 
	Если Периодичность <> Перечисления.Периодичность.Месяц Тогда
		Элементы.НомерДня.Подсказка = "";
	КонецЕсли;
	
	Элементы.ВариантРаспределнияДат.СписокВыбора.Очистить();
	Элементы.ГруппаРаспределениеПоНеделям.Видимость = Ложь;
	
	Если ДобавлятьВариантПолугодия Тогда
		Элементы.ВариантРаспределнияДат.СписокВыбора.Добавить("ПоПолугодиям", НСтр("ru = 'По полугодиям'"));
	КонецЕсли;
	Если ДобавлятьВариантКвартала Тогда
		Элементы.ВариантРаспределнияДат.СписокВыбора.Добавить("ПоКварталам", НСтр("ru = 'По кварталам'"));
	КонецЕсли;
	Если ДобавлятьВариантМесяца Тогда
		Элементы.ВариантРаспределнияДат.СписокВыбора.Добавить("ПоМесяцам", НСтр("ru = 'По месяцам'"));
	КонецЕсли;
	Если ДобавлятьВариантДекады Тогда
		Элементы.ВариантРаспределнияДат.СписокВыбора.Добавить("ПоДекадам", НСтр("ru = 'По декадам'"));
	КонецЕсли;
	Если ДобавлятьВариантНедели Тогда
		Элементы.ГруппаРаспределениеПоНеделям.Видимость = Истина;
	КонецЕсли;
	
	Элементы.ВариантРаспределнияДат.Видимость = Элементы.ВариантРаспределнияДат.СписокВыбора.Количество() > 0;
	
	ДеньНедели = Перечисления.ДниНедели.Понедельник;
	
	ВариантРаспределенияДат = "ПоНеделям";
	ВариантРаспределенияКоличества = "Пропорционально";
	
	ОтметитьКЗаказу = Истина;
	РасчитатьКоличествоПериодовПоУмолчанию(КоличествоПериодов, Периодичность, ВариантРаспределенияДат, ДатаПоступления, ДеньНедели);
	
	// Считываем сохраненный предыдущий выбор
	ПараметрыРаспределения = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить(
		Строка(Сценарий.УникальныйИдентификатор())+ТипПланирования,
		"ПараметрыРаспределения");
	Если ТипЗнч(ПараметрыРаспределения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыРаспределения,, "Доли");
		РасчитатьКоличествоПериодовПоУмолчанию(КоличествоПериодов, Периодичность, ВариантРаспределенияДат, ДатаПоступления, ДеньНедели);
		
		Если ПараметрыРаспределения.Свойство("Доли") И ВариантРаспределенияКоличества <> "Пропорционально" Тогда
			
			Для каждого Доля Из ПараметрыРаспределения.Доли Цикл
			
				НоваяСтрока = Доли.Добавить();
				НоваяСтрока.Доля = Доля;
			
			КонецЦикла;
			
		КонецЕсли; 
	КонецЕсли;
	
	ЗаполнитьДоли(Доли, КоличествоПериодов, ВариантРаспределенияДат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОперацияПриИзменении(Элемент)
	
	УстановитьДоступностьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПереносаПриИзменении(Элемент)
	
	УстановитьДоступностьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура НомерДняПриИзменении(Элемент)
	
	ОбновитьПодсказкуПереноса();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиПервыйПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ДеньНедели) Тогда
		ДеньНедели = ПредопределенноеЗначение("Перечисление.ДниНедели.Понедельник");
	КонецЕсли;
	
	ОбновитьПодсказкуПереноса();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиПоследнийПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ДеньНедели) Тогда
		ДеньНедели = ПредопределенноеЗначение("Перечисление.ДниНедели.Понедельник");
	КонецЕсли;
	
	ОбновитьПодсказкуПереноса();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРаспределенияДатПриИзменении(Элемент)
	
	РасчитатьКоличествоПериодовПоУмолчанию(КоличествоПериодов, Периодичность, ВариантРаспределенияДат, ДатаПоступления, ДеньНедели);
	
	ЗаполнитьДоли(Доли, КоличествоПериодов, ВариантРаспределенияДат);
	
	УстановитьДоступностьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиРаспределениеПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ДеньНедели) Тогда
		ДеньНедели = ПредопределенноеЗначение("Перечисление.ДниНедели.Понедельник");
	КонецЕсли;
	
	РасчитатьКоличествоПериодовПоУмолчанию(КоличествоПериодов, Периодичность, ВариантРаспределенияДат, ДатаПоступления, ДеньНедели);
	ЗаполнитьДоли(Доли, КоличествоПериодов, ВариантРаспределенияДат);
	ОбновитьПодсказкуРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПериодовПриИзменении(Элемент)
	
	ЗаполнитьДоли(Доли, КоличествоПериодов, ВариантРаспределенияДат);
	ОбновитьПодсказкуРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРаспределенияКоличестваПриИзменении(Элемент)
	
	Если ВариантРаспределенияКоличества = "Пропорционально" Тогда
		
		Доли.Очистить();
		ЗаполнитьДоли(Доли, КоличествоПериодов, ВариантРаспределенияДат);
		
	КонецЕсли; 
	
	УстановитьДоступностьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	Если ВариантРаспределенияКоличества = "ПоДолям" И Элементы.СтраницыРаспределение.ТекущаяСтраница = Элементы.ГруппаОсновное Тогда
		
		Элементы.СтраницыРаспределение.ТекущаяСтраница = Элементы.ГруппаДоли;
		УстановитьДоступностьВидимость();
		
	Иначе
		
		// сохраняем настройки
		ПараметрыРаспределения = СформироватьИСохранитьНастройкиНаСервере();
		
		Закрыть(ПараметрыРаспределения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.СтраницыРаспределение.ТекущаяСтраница = Элементы.ГруппаОсновное;
	УстановитьДоступностьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступностьВидимость()

	Если Операция = "Перенос" Тогда
		
		Элементы.СтраницыОперации.ТекущаяСтраница = Элементы.СтраницаПеренос;
		
		ОбновитьПодсказкуПереноса();
		
		Элементы.ФормаДалее.Заголовок = НСтр("ru = 'Перенести'");
		
		Элементы.НомерДня.Доступность = ВариантПереноса = "НаЧисло";
		Элементы.ДеньНеделиПервый.Доступность = ВариантПереноса = "НаПервыйДеньНедели";
		Элементы.ДеньНеделиПоследний.Доступность = ВариантПереноса = "НаПоследнийДеньНедели";
		
	ИначеЕсли Операция = "Распределение" Тогда
		
		Элементы.СтраницыОперации.ТекущаяСтраница = Элементы.СтраницаРаспределение;
		
		ОбновитьПодсказкуРаспределения();
		
		Элементы.КоличествоПериодов.Доступность = ВариантРаспределенияДат = "ПоПериодам";
		Элементы.ДеньНеделиРаспределение.Доступность = ВариантРаспределенияДат = "ПоНеделям";
		
		Если ВариантРаспределенияКоличества = "Пропорционально" ИЛИ Элементы.СтраницыРаспределение.ТекущаяСтраница = Элементы.ГруппаДоли Тогда
		
		
			Элементы.ФормаДалее.Заголовок = НСтр("ru = 'Распределить'");
		
		
		Иначе
		
			Элементы.ФормаДалее.Заголовок = НСтр("ru = 'Далее >'");
		
		КонецЕсли;
		
	КонецЕсли; 
	
	Если Операция = "Распределение" 
		И ВариантРаспределенияКоличества = "ПоДолям" 
		И Элементы.СтраницыРаспределение.ТекущаяСтраница = Элементы.ГруппаДоли Тогда
		Элементы.ФормаНазад.Видимость = Истина;
	Иначе
		Элементы.ФормаНазад.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПодсказкуПереноса()

	Если ТипПланирования = "ПланированиеПроизводства" Тогда
		ШаблонПодсказки = НСтр("ru = 'Например, дата выпуска %ТекущаяДатаПоступления% будет перенесена на %НоваяДатаПоступления%.'");
	ИначеЕсли ТипПланирования = "ПланированиеСборкиРазборки" Тогда
		ШаблонПодсказки = НСтр("ru = 'Например, дата сборки (разборки) %ТекущаяДатаПоступления% будет перенесена на %НоваяДатаПоступления%.'");
	ИначеЕсли ТипПланирования = "ПланированиеПередачиМатериаловВПроизводство" Тогда
		ШаблонПодсказки = НСтр("ru = 'Например, дата отгрузки материалов %ТекущаяДатаПоступления% будет перенесена на %НоваяДатаПоступления%.'");
	Иначе
		ШаблонПодсказки = НСтр("ru = 'Например, дата поступления %ТекущаяДатаПоступления% будет перенесена на %НоваяДатаПоступления%.'");
	КонецЕсли;
	
	Если ВариантПереноса = "НаЧисло" Тогда
	
		НоваяДатаПоступления = ДатаПоступления + (НомерДня-1) * 86400;
	
	ИначеЕсли ВариантПереноса = "НаПервыйДеньНедели" Тогда
		
		НомерДняНедели = НомерДняНедели(ДеньНедели);
		ТекущийНомерДняНедели = ДеньНедели(ДатаПоступления);
		
		Если ТекущийНомерДняНедели > НомерДняНедели Тогда
		
			НоваяДатаПоступления = ДатаПоступления + (7 + НомерДняНедели - ТекущийНомерДняНедели) * 86400;
			
		ИначеЕсли ТекущийНомерДняНедели < НомерДняНедели Тогда
			НоваяДатаПоступления = ДатаПоступления + (НомерДняНедели - ТекущийНомерДняНедели) * 86400;
		Иначе
			НоваяДатаПоступления = ДатаПоступления;
		КонецЕсли; 
		
	ИначеЕсли ВариантПереноса = "НаПоследнийДеньНедели" Тогда
		
		НомерДняНедели = НомерДняНедели(ДеньНедели);
		ТекущийНомерДняНедели = ДеньНедели(ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(ДатаПоступления, Периодичность));
		
		Если ТекущийНомерДняНедели > НомерДняНедели Тогда
		
			НоваяДатаПоступления = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(ДатаПоступления, Периодичность) - (ТекущийНомерДняНедели - НомерДняНедели) * 86400;
			
		ИначеЕсли ТекущийНомерДняНедели < НомерДняНедели Тогда
			НоваяДатаПоступления = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(ДатаПоступления, Периодичность) - (7 - НомерДняНедели + ТекущийНомерДняНедели) * 86400;
		Иначе
			НоваяДатаПоступления = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(ДатаПоступления, Периодичность);
		КонецЕсли;
	
	КонецЕсли; 
	
	ШаблонПодсказки = СтрЗаменить(ШаблонПодсказки, "%ТекущаяДатаПоступления%", Формат(ДатаПоступления, "ДЛФ=D"));
	ШаблонПодсказки = СтрЗаменить(ШаблонПодсказки, "%НоваяДатаПоступления%", Формат(НоваяДатаПоступления, "ДЛФ=D"));
	ПодсказкаПереноса = ШаблонПодсказки;

КонецПроцедуры 

&НаКлиенте
Процедура ОбновитьПодсказкуРаспределения()
	
	Если ВариантРаспределенияДат = "ПоНеделям" Тогда
		
		Если ТипПланирования = "ПланированиеПроизводства" Тогда
			ШаблонПодсказки = НСтр("ru = 'Например, выпуск %ТекущаяДатаПоступления% распределен на %КоличествоПериодов% периода(ов), в зависимости от конкретного месяца. Выпуск будет в %ДеньНедели%.'");
		ИначеЕсли ТипПланирования = "ПланированиеСборкиРазборки" Тогда
			ШаблонПодсказки = НСтр("ru = 'Например, сборка(разборка) %ТекущаяДатаПоступления% распределена на %КоличествоПериодов% периода(ов), в зависимости от конкретного месяца. Сборка (разборка) будет в %ДеньНедели%.'");
		ИначеЕсли ТипПланирования = "ПланированиеПередачиМатериаловВПроизводство" Тогда
			ШаблонПодсказки = НСтр("ru = 'Например, отгрузка материалов %ТекущаяДатаПоступления% распределена на %КоличествоПериодов% периода(ов), в зависимости от конкретного месяца. Сборка (разборка) будет в %ДеньНедели%.'");
		Иначе
			ШаблонПодсказки = НСтр("ru = 'Например, поступление %ТекущаяДатаПоступления% распределено на %КоличествоПериодов% периода(ов), в зависимости от конкретного месяца. Поступления будут в %ДеньНедели%.'");
		КонецЕсли;
		СтрокаКоличествоПериодов = Формат(КоличествоПериодов, "ЧДЦ=; ЧГ=0");
		ШаблонПодсказки = СтрЗаменить(ШаблонПодсказки, "%КоличествоПериодов%", СтрокаКоличествоПериодов);
		ШаблонПодсказки = СтрЗаменить(ШаблонПодсказки, "%ДеньНедели%", Элементы.ДеньНеделиРаспределение.СписокВыбора.НайтиПоЗначению(ДеньНедели).Представление);
		
	ИначеЕсли ВариантРаспределенияДат = "ПоДекадам" Тогда
		
		Если ТипПланирования = "ПланированиеПроизводства" Тогда
			ШаблонПодсказки = НСтр("ru = 'Например, выпуск %ТекущаяДатаПоступления% распределен на 3 декады. Даты выпуска установлены на 1, 11 и 21 число месяца.'");
		ИначеЕсли ТипПланирования = "ПланированиеСборкиРазборки" Тогда
			ШаблонПодсказки = НСтр("ru = 'Например, сборка (разборка) %ТекущаяДатаПоступления% распределена на 3 декады. Даты сборок (разборок) установлены на 1, 11 и 21 число месяца.'");
		ИначеЕсли ТипПланирования = "ПланированиеПередачиМатериаловВПроизводство" Тогда
			ШаблонПодсказки = НСтр("ru = 'Например, отгрузка материалов %ТекущаяДатаПоступления% распределена на 3 декады. Даты сборок (разборок) установлены на 1, 11 и 21 число месяца.'");
		Иначе
			ШаблонПодсказки = НСтр("ru = 'Например, поступление %ТекущаяДатаПоступления% распределено на 3 декады. Даты поступления установлены на 1, 11 и 21 число месяца.'");
		КонецЕсли;
		
	ИначеЕсли ВариантРаспределенияДат = "ПоПериодам" Тогда
		
		Если ТипПланирования = "ПланированиеПроизводства" Тогда
			ШаблонПодсказки = НСтр("ru = 'Например, выпуск %ТекущаяДатаПоступления% распределен на %КоличествоПериодов% периода(ов). Даты выпуска установлены первый день каждого периода.'");
		ИначеЕсли ТипПланирования = "ПланированиеСборкиРазборки" Тогда
			ШаблонПодсказки = НСтр("ru = 'Например, сборка (разборка) %ТекущаяДатаПоступления% распределена на %КоличествоПериодов% периода(ов). Даты сборок (разборок) установлены первый день каждого периода.'");
		ИначеЕсли ТипПланирования = "ПланированиеПередачиМатериаловВПроизводство" Тогда
			ШаблонПодсказки = НСтр("ru = 'Например, отгрузка материалов %ТекущаяДатаПоступления% распределена на %КоличествоПериодов% периода(ов). Даты сборок (разборок) установлены первый день каждого периода.'");
		Иначе
			ШаблонПодсказки = НСтр("ru = 'Например, поступление %ТекущаяДатаПоступления% распределено на %КоличествоПериодов% периода(ов). Даты поступления установлены первый день каждого периода.'");
		КонецЕсли;
		СтрокаКоличествоПериодов = Формат(КоличествоПериодов, "ЧДЦ=; ЧГ=0") ;
		ШаблонПодсказки = СтрЗаменить(ШаблонПодсказки, "%КоличествоПериодов%", СтрокаКоличествоПериодов);
		
	КонецЕсли;
	
	ШаблонПодсказки = СтрЗаменить(ШаблонПодсказки, "%ТекущаяДатаПоступления%", Формат(ДатаПоступления, "ДЛФ=D"));
	ПодсказкаРаспределение = ШаблонПодсказки;

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Функция НомерДняНедели(ДеньНедели)

	Возврат ПланированиеКлиентСервер.НомерДняНедели(ДеньНедели);

КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДоли(Доли, КоличествоПериодов, ВариантРаспределенияДат)
	
	Если ВариантРаспределенияДат = "ПоПолугодиям" Тогда
		
		ПредставлениеПериода = НСтр("ru = 'полугодие'");
		ПредставлениеПоследнегоПериода = НСтр("ru = 'полугодие'");
		
	ИначеЕсли ВариантРаспределенияДат = "ПоКварталам" Тогда
		
		ПредставлениеПериода = НСтр("ru = 'квартал'");
		ПредставлениеПоследнегоПериода = НСтр("ru = 'квартал'");
		
	ИначеЕсли ВариантРаспределенияДат = "ПоМесяцам" Тогда
		
		ПредставлениеПериода = НСтр("ru = 'месяц'");
		ПредставлениеПоследнегоПериода = НСтр("ru = 'месяц'");
		
	ИначеЕсли ВариантРаспределенияДат = "ПоНеделям" Тогда
		
		ПредставлениеПериода = НСтр("ru = 'неделя'");
		ПредставлениеПоследнегоПериода = НСтр("ru = 'неделя (если есть)'");
		
	ИначеЕсли ВариантРаспределенияДат = "ПоДекадам" Тогда
		
		ПредставлениеПериода = НСтр("ru = 'декада'");
		ПредставлениеПоследнегоПериода = НСтр("ru = 'декада'");
		
	ИначеЕсли ВариантРаспределенияДат = "ПоПериодам" Тогда
		
		ПредставлениеПериода = НСтр("ru = 'период'");
		ПредставлениеПоследнегоПериода = НСтр("ru = 'период (если есть)'");
		
	КонецЕсли;
	
	Если КоличествоПериодов = Доли.Количество() Тогда
		
		Для каждого СтрокаТЧ Из Доли Цикл
			
			Период = Доли.Индекс(СтрокаТЧ) + 1;
			СтрокаТЧ.Период = Период;
			Если КоличествоПериодов = Период Тогда
				СтрокаТЧ.Представление = Строка(Период) + " " + ПредставлениеПоследнегоПериода;
			Иначе
				СтрокаТЧ.Представление = Строка(Период) + " " + ПредставлениеПериода;
			КонецЕсли;
			Если ВариантРаспределенияДат = "ПоДекадам" Тогда
				Если (Период % 3) = 1  Тогда
					СтрокаТЧ.Представление = СтрокаТЧ.Представление + НСтр("ru = ': с 1 по 10'");
				ИначеЕсли (Период % 3) = 2 Тогда
					СтрокаТЧ.Представление = СтрокаТЧ.Представление + НСтр("ru = ': с 11 по 20'");
				Иначе
					СтрокаТЧ.Представление = СтрокаТЧ.Представление + НСтр("ru = ': с 21'");
				КонецЕсли; 
			КонецЕсли;
		КонецЦикла; 
	Иначе
	
		Доли.Очистить();
		
		Для Период =1 По КоличествоПериодов Цикл
			
			НоваяСтрока = Доли.Добавить();
			
			НоваяСтрока.Период = Период;
			Если КоличествоПериодов = Период Тогда
				НоваяСтрока.Представление = Строка(Период) + " " + ПредставлениеПоследнегоПериода;
			Иначе
				НоваяСтрока.Представление = Строка(Период) + " " + ПредставлениеПериода;
			КонецЕсли; 
			НоваяСтрока.Доля = 1;
			Если ВариантРаспределенияДат = "ПоДекадам" Тогда
				Если (Период % 3) = 1  Тогда
					НоваяСтрока.Представление = НоваяСтрока.Представление + НСтр("ru = ': с 1 по 10'");
				ИначеЕсли (Период % 3) = 2 Тогда
					НоваяСтрока.Представление = НоваяСтрока.Представление + НСтр("ru = ': с 11 по 20'");
				Иначе
					НоваяСтрока.Представление = НоваяСтрока.Представление + НСтр("ru = ': с 21'");
				КонецЕсли; 
			КонецЕсли;
		КонецЦикла; 
	
	КонецЕсли; 

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РасчитатьКоличествоПериодовПоУмолчанию(КоличествоПериодов, Периодичность, ВариантРаспределенияДат, ДатаПоступления, ДеньНедели)

	Если ВариантРаспределенияДат = "ПоПериодам" Тогда
		Возврат;
	КонецЕсли;
	
	Если ВариантРаспределенияДат = "ПоПолугодиям" Тогда
		
		Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
			КоличествоПериодов = 2;
		Иначе
			КоличествоПериодов = 1;
		КонецЕсли; 
		
	ИначеЕсли ВариантРаспределенияДат = "ПоКварталам" Тогда
		
		Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
			КоличествоПериодов = 4;
		ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
			КоличествоПериодов = 2;
		Иначе
			КоличествоПериодов = 1;
		КонецЕсли; 
		
	ИначеЕсли ВариантРаспределенияДат = "ПоМесяцам" Тогда
		
		Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
			КоличествоПериодов = 12;
		ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
			КоличествоПериодов = 6;
		ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
			КоличествоПериодов = 3;
		Иначе
			КоличествоПериодов = 1;
		КонецЕсли; 
		
	ИначеЕсли ВариантРаспределенияДат = "ПоНеделям" Тогда
		
		Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
			КоличествоПериодов = 54;
		ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
			КоличествоПериодов = 27;
		ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
			КоличествоПериодов = 14;
		ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
			
			НомерДняНедели = НомерДняНедели(ДеньНедели);
			НачалоПериода = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуНачалаПериода(ДатаПоступления, Периодичность);
			ОкончаниеПериода = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(ДатаПоступления, Периодичность);
				
			ТекущийДеньНедели = ДеньНедели(НачалоПериода);
			Если ТекущийДеньНедели <= НомерДняНедели Тогда
				ПервыйПериод = НачалоПериода  + (НомерДняНедели - ТекущийДеньНедели) * 86400;
			Иначе
				ПервыйПериод = КонецНедели(НачалоПериода) + 1 + (НомерДняНедели -1) * 86400;
			КонецЕсли;
			
			ТекущийДеньНедели = ДеньНедели(ОкончаниеПериода);
			Если ТекущийДеньНедели >= НомерДняНедели Тогда
				ПоследнийПериод = НачалоНедели(ОкончаниеПериода) + (НомерДняНедели -1) * 86400;
			Иначе
				ПоследнийПериод = НачалоНедели(ОкончаниеПериода)- (8 - НомерДняНедели) * 86400;
			КонецЕсли;
			
			КоличествоПериодов = Цел((ПоследнийПериод - ПервыйПериод) / 604800) + 1;
			
		ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
			КоличествоПериодов = 2;
		Иначе
			КоличествоПериодов = 1;
		КонецЕсли; 
		
	ИначеЕсли ВариантРаспределенияДат = "ПоДекадам" Тогда
	
		Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
			КоличествоПериодов = 36;
		ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
			КоличествоПериодов = 18;
		ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
			КоличествоПериодов = 9;
		ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
			КоличествоПериодов = 3;
		Иначе
			КоличествоПериодов = 1;
		КонецЕсли; 
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьИСохранитьНастройкиНаСервере()
	
	ПараметрыРаспределения = Новый Структура;
	ПараметрыРаспределения.Вставить("Операция", Операция);
	
	ПараметрыРаспределения.Вставить("ВариантПереноса", ВариантПереноса);
	ПараметрыРаспределения.Вставить("НомерДня", НомерДня);
	ПараметрыРаспределения.Вставить("ДеньНедели", ДеньНедели);
	ПараметрыРаспределения.Вставить("ТипПланирования", ТипПланирования);
	ПараметрыРаспределения.Вставить("Периодичность", Периодичность);
	
	ПараметрыРаспределения.Вставить("ВариантРаспределенияДат", ВариантРаспределенияДат);
	ПараметрыРаспределения.Вставить("КоличествоПериодов", КоличествоПериодов);
	ПараметрыРаспределения.Вставить("ВариантРаспределенияКоличества", ВариантРаспределенияКоличества);
	ПараметрыРаспределения.Вставить("ТочностьОкругления", ТочностьОкругления);
	ПараметрыРаспределения.Вставить("ОтметитьКЗаказу", ОтметитьКЗаказу);
	ПараметрыРаспределения.Вставить("Доли", Доли.Выгрузить(,"Доля").ВыгрузитьКолонку("Доля"));
	
	// Сохраняем настройки в разрезе сценария
	
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(
		Строка(Сценарий.УникальныйИдентификатор())+ТипПланирования,
		"ПараметрыРаспределения",
		ПараметрыРаспределения);
	
	Возврат ПараметрыРаспределения;

КонецФункции
 
#КонецОбласти
