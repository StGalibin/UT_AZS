﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработатьВыборКонтрагентаДляСопоставления(ВыбранноеЗначение, ИсточникВыбора, Объект);
	
	Если ТипЗнч(ВыбранноеЗначение) = ТипЗнч(СтороннийТорговыйОбъектЗначениеПоУмолчанию) Тогда
		ЗаполнитьПартнера(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФормЕГАИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_КлассификаторОрганизацийЕГАИС", Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СопоставитьПоИННКПП(Команда)
	
	ОчиститьСообщения();
	
	КонтрагентНайден = СопоставитьПоИННКППСервер();
	
	Если Не КонтрагентНайден Тогда
		Если ЕстьПравоСозданияКонтрагента Тогда
			ТекстВопроса = НСтр("ru='Контрагент с указанными ИНН и КПП не найден. Создать нового?'");
			ПоказатьВопрос(Новый ОписаниеОповещения("СоздатьНовогоКонтрагента", ЭтотОбъект), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Контрагент с указанными ИНН и КПП не найден.'"),
			                                                  ,
			                                                  "ИНН",
			                                                  "Объект");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьАлкогольнуюПродукцию(Команда)
	
	Если Модифицированность ИЛИ НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Элемент не сохранен'"));
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.ИНН) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнен ИНН организации'"),, "Объект.ИНН");
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидДокументаЕГАИС", ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросАлкогольнойПродукции"));
	ПараметрыФормы.Вставить("ЗначениеПараметра", Объект.ИНН);
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормированиеИсходящегоЗапросаЕГАИС",
		ПараметрыФормы,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ЗапросАлкогольнойПродукции_Завершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	ПриИзмененииИНН(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИННИППриИзменении(Элемент)
	
	ПриИзмененииИНН(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КПППриИзменении(Элемент)
	
	ТекстСообщения = "";
	Если Не ПустаяСтрока(Объект.КПП)
		И Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Объект.КПП, ТекстСообщения) Тогда
		
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,"КПП",,);
			
	КонецЕсли;
	
	СоответствуетОрганизацииПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ТорговыйОбъектПриИзменении(Элемент)
	
	ЗаполнитьДанныеСопоставления();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЗаполнитьДанныеСопоставления();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	КонтрагентПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СтороннийТорговыйОбъектПриИзменении(Элемент)
	
	СтороннийТорговыйОбъектПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СоответствуетОрганизацииПриИзменении(Элемент)
	
	Если Объект.СоответствуетОрганизации Тогда
		Объект.Контрагент = СобственнаяОрганизацияЗначениеПоУмолчанию;
		Объект.ТорговыйОбъект = СобственныйТорговыйОбъектЗначениеПоУмолчанию;
	Иначе
		Объект.Контрагент = СторонняяОрганизацияЗначениеПоУмолчанию;
		Объект.ТорговыйОбъект = СтороннийТорговыйОбъектЗначениеПоУмолчанию;
	КонецЕсли;
	
	СоответствуетОрганизацииПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОрганизацииПриИзменении(Элемент)
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматОбменаПриИзменении(Элемент)
	
	Если Объект.СоответствуетОрганизации Тогда
	
		ИзмененФорматОбмена = ИсходныйФорматОбмена <> Объект.ФорматОбмена И ЗначениеЗаполнено(ИсходныйФорматОбмена);
		
		Если ИзмененФорматОбмена Тогда
			
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Выгрузить в ЕГАИС'"));
			Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Отменить'"));
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", Новый ОписаниеОповещения("ЗаписьНастройки_ПослеВыгрузкиИнформацииВЕГАИС", ЭтотОбъект));
			
			ПоказатьВопрос(
				Новый ОписаниеОповещения("ВыгрузкаИнформацииОФорматеОбмена_Подтверждение", ЭтотОбъект, ДополнительныеПараметры),
				НСтр("ru='Изменился формат обмена с ЕГАИС.'"),
				Кнопки);
				
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоответствуетОрганизацииПриИзмененииСервер()
	
	Объект.СоответствуетОрганизации = Булево(СоответствуетОрганизации);
	
	Элементы.ГруппаСобственнаяОрганизация.Видимость = Объект.СоответствуетОрганизации;
	Элементы.ГруппаСторонняяОрганизация.Видимость = НЕ Объект.СоответствуетОрганизации;
	
	РассчитатьСопоставлено();
	
	ЗаполнитьДанныеСопоставления();
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура СтороннийТорговыйОбъектПриИзмененииНаСервере()
	
	СобытияФормЕГАИСПереопределяемый.ПриИзмененииПартнераВФормеКлассификатора(ЭтотОбъект);
	ЗаполнитьДанныеСопоставления();
	
	РассчитатьСопоставлено();
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()
	
	СобытияФормЕГАИСПереопределяемый.ПриИзмененииКонтрагентаВФормеКлассификатора(ЭтотОбъект);
	ЗаполнитьДанныеСопоставления();
	
	РассчитатьСопоставлено();
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииИНН(ЭтоЮрЛицо)
	
	ТекстСообщения = "";
	Если Не ПустаяСтрока(Объект.ИНН)
		И Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Объект.ИНН, ЭтоЮрЛицо, ТекстСообщения) Тогда
		
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,"ИНН",,);
		
	КонецЕсли;
	
	СоответствуетОрганизацииПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСопоставлено()
	
	Объект.Сопоставлено = Справочники.КлассификаторОрганизацийЕГАИС.РассчитатьСопоставлено(
		Объект.ТорговыйОбъект,
		Объект.Контрагент,
		Объект.СоответствуетОрганизации);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПартнера(Партнер)
	
	Объект.ТорговыйОбъект = Партнер;
	
	РассчитатьСопоставлено();
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Элементы.СопоставитьПоИННКПП.Доступность = ЗначениеЗаполнено(Объект.ИНН) И Не Объект.Сопоставлено;
	Элементы.СопоставитьПоИНН.Доступность = ЗначениеЗаполнено(Объект.ИНН) И Не Объект.Сопоставлено;
	
	Элементы.ГруппаЮЛ.Видимость = Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЕГАИС.ЮридическоеЛицоРФ")
		ИЛИ Объект.ТипОрганизации.Пустая();
		
	Элементы.ГруппаИП.Видимость = Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЕГАИС.ИндивидуальныйПредпринимательРФ");
	Элементы.ГруппаТС.Видимость = Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЕГАИС.КонтрагентТаможенногоСоюза");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросАлкогольнойПродукции_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") ИЛИ НЕ Результат.Результат Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИСКлиент.СообщитьОЗавершенииФормированияИсходящегоЗапроса();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеСопоставления()
	
	ДанныеСопоставления = Неопределено;
	
	Если Объект.Контрагент <> Неопределено Тогда
		ДанныеСопоставления = ИнтеграцияЕГАИСПереопределяемый.ИННКППСопоставленнойОрганизации(Объект.Контрагент, Объект.ТорговыйОбъект);
	КонецЕсли;
	
	Если ДанныеСопоставления <> Неопределено Тогда
		
		ИНН = ДанныеСопоставления.ИНН;
		КПП = ДанныеСопоставления.КПП;
		
		Элементы.ИННОрганизацииНеСоответствуетОрганизацииЕГАИС.Видимость = ДанныеСопоставления.ИНН <> Объект.ИНН И Объект.СоответствуетОрганизации;
		Элементы.КППОрганизацииНеСоответствуетОрганизацииЕГАИС.Видимость = ДанныеСопоставления.КПП <> Объект.КПП И Объект.СоответствуетОрганизации;
		Элементы.ИННКонтрагентаНеСоответствуетОрганизацииЕГАИС.Видимость = ДанныеСопоставления.ИНН <> Объект.ИНН И НЕ Объект.СоответствуетОрганизации;
		Элементы.КППКонтрагентаНеСоответствуетОрганизацииЕГАИС.Видимость = ДанныеСопоставления.КПП <> Объект.КПП И НЕ Объект.СоответствуетОрганизации;
		
	Иначе
		
		ИНН = "";
		КПП = "";
		
		Элементы.ИННОрганизацииНеСоответствуетОрганизацииЕГАИС.Видимость = Ложь;
		Элементы.КППОрганизацииНеСоответствуетОрганизацииЕГАИС.Видимость = Ложь;
		Элементы.ИННКонтрагентаНеСоответствуетОрганизацииЕГАИС.Видимость = Ложь;
		Элементы.КППКонтрагентаНеСоответствуетОрганизацииЕГАИС.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	СоответствуетОрганизации = Объект.СоответствуетОрганизации;
	
	ИнтеграцияЕГАИСПереопределяемый.ЗначенияПоУмолчаниюНеСопоставленныхОбъектов(
		СобственнаяОрганизацияЗначениеПоУмолчанию,
		СобственныйТорговыйОбъектЗначениеПоУмолчанию,
		СторонняяОрганизацияЗначениеПоУмолчанию,
		СтороннийТорговыйОбъектЗначениеПоУмолчанию);
		
	МассивТиповСобственнаяОрганизация = Новый Массив;
	МассивТиповСобственныйТорговыйОбъект = Новый Массив;
	МассивТиповСторонняяОрганизация = Новый Массив;
	МассивТиповСтороннийТорговыйОбъект = Новый Массив;
	
	МассивТиповСобственнаяОрганизация.Добавить(ТипЗнч(СобственнаяОрганизацияЗначениеПоУмолчанию));
	МассивТиповСобственныйТорговыйОбъект.Добавить(ТипЗнч(СобственныйТорговыйОбъектЗначениеПоУмолчанию));
	МассивТиповСторонняяОрганизация.Добавить(ТипЗнч(СторонняяОрганизацияЗначениеПоУмолчанию));
	МассивТиповСтороннийТорговыйОбъект.Добавить(ТипЗнч(СтороннийТорговыйОбъектЗначениеПоУмолчанию));
	
	Элементы.Организация.ОграничениеТипа = Новый ОписаниеТипов(МассивТиповСобственнаяОрганизация);
	Элементы.ТорговыйОбъект.ОграничениеТипа = Новый ОписаниеТипов(МассивТиповСобственныйТорговыйОбъект);
	Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов(МассивТиповСторонняяОрганизация);
	Элементы.СтороннийТорговыйОбъект.ОграничениеТипа = Новый ОписаниеТипов(МассивТиповСтороннийТорговыйОбъект);
	
	Если СтороннийТорговыйОбъектЗначениеПоУмолчанию = Неопределено Тогда
		Элементы.ГруппаСтороннийТорговыйОбъект.Видимость = Ложь;
	КонецЕсли;
	
	ИсходныйФорматОбмена = Объект.ФорматОбмена;
	
	ЕстьПравоСозданияКонтрагента = ИнтеграцияЕГАИСПереопределяемый.ЕстьПравоСозданияКонтрагента();
	
	СоответствуетОрганизацииПриИзмененииСервер();
	
	ЗаполнитьДанныеСопоставления();
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписьНастройки_ПослеВыгрузкиИнформацииВЕГАИС(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Ложь Тогда
		
		Объект.ФорматОбмена = ИсходныйФорматОбмена;
		
	Иначе
		
		Записать();
		
		ИсходныйФорматОбмена = Объект.ФорматОбмена;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузкаИнформацииОФорматеОбмена_Подтверждение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Ложь);
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Массив;
	Отбор.Добавить(Новый Структура("Поле, Значение", "ИдентификаторФСРАР", Объект.Код));
	Отбор.Добавить(Новый Структура("Поле, Значение", "РабочееМесто", МенеджерОборудованияКлиентПовтИсп.ПолучитьРабочееМестоКлиента()));
	
	ДоступныеМодули = ИнтеграцияЕГАИСВызовСервера.ДоступныеТранспортныеМодули(Отбор);
	Если ДоступныеМодули.Количество() = 0 Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Ложь);
		Возврат;
	КонецЕсли;
	
	ТранспортныйМодуль = ДоступныеМодули[0];
	
	ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ИнформацияОФорматеОбмена");
	
	ВходныеПараметры = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ВидДокумента);
	ВходныеПараметры.ИдентификаторФСРАР = Объект.Код;
	ВходныеПараметры.ФорматОбмена       = Объект.ФорматОбмена;
	
	ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(
		Новый ОписаниеОповещения("ВыгрузкаИнформацииОФорматеОбмена_Завершение", ЭтотОбъект, ДополнительныеПараметры),
		ВидДокумента,
		ВходныеПараметры,
		ТранспортныйМодуль);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузкаИнформацииОФорматеОбмена_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Результат.Результат)
	
КонецПроцедуры

#Область СопоставлениеПартнеров

&НаСервере
Функция СопоставитьПоИННКППСервер()
	
	Если Объект.СоответствуетОрганизации Тогда
		
		НайденнаяОрганизация = ИнтеграцияЕГАИСПереопределяемый.ОрганизацияПоИННКПП(Объект.ИНН, Объект.КПП);
		Если ЗначениеЗаполнено(НайденнаяОрганизация) Тогда
			Объект.Контрагент = НайденнаяОрганизация;
		КонецЕсли;
		
		РассчитатьСопоставлено();
		УстановитьВидимостьДоступность();
		
		Возврат Истина;
		
	Иначе
		
		СтруктураКонтрагентТорговыйОбъект = ИнтеграцияЕГАИСПереопределяемый.КонтрагентТорговыйОбъектПоИННКПП(Объект.ИНН, Объект.КПП);
		Если ЗначениеЗаполнено(СтруктураКонтрагентТорговыйОбъект) Тогда
			
			Объект.Контрагент     = СтруктураКонтрагентТорговыйОбъект.Контрагент;
			Объект.ТорговыйОбъект = СтруктураКонтрагентТорговыйОбъект.ТорговыйОбъект;
			
			РассчитатьСопоставлено();
			УстановитьВидимостьДоступность();
			
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура СоздатьНовогоКонтрагента(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ДанныеКонтрагента = Новый Структура;
		ДанныеКонтрагента.Вставить("Наименование", Объект.НаименованиеПолное);
		ДанныеКонтрагента.Вставить("ИНН",          Объект.ИНН);
		ДанныеКонтрагента.Вставить("КПП",          Объект.КПП);
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуСозданияНовогоКонтрагента(ДанныеКонтрагента, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
