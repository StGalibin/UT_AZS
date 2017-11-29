﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ОбменДаннымиУТ.ВЭтомУзлеДоступноВыполнениеОперацийЗакрытияМесяца(Отказ) Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПериодРегистрации") Тогда
		Объект.Дата = Параметры.ПериодРегистрации;
	КонецЕсли;
	
	// Контроль создания документа в подчиенном узле РИБ с фильтрами
	ОбменДаннымиУТУП.КонтрольСозданияДокументовВРаспределеннойИБ(Объект, Отказ);

	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();

	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьНадписьПериод();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("Запись_РаспределениеНДС");
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ Объект.БазаРаспределенияУстанавливаетсяВручную Тогда
		ЗаполнитьБазуРаспределенияПоВыручкеСервер();
	КонецЕсли;
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ОбновитьНадписьПериод();
	ПериодПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыручкаНеНДСПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыручкаЕНВДПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура БазаВыручкаНДС0НесырьевыеТоварыПриИзменении(Элемент)
	
	Объект.ВыручкаНДС0 = Объект.ВыручкаНДС0СырьевыеТоварыУслуги + Объект.ВыручкаНДС0НесырьевыеТовары;
	
КонецПроцедуры

&НаКлиенте
Процедура СписатьНДСПоРасходамАктивамНаСтатьиОтраженияПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовНеНДСПриИзменении(Элемент)
	
	Элементы.АналитикаРасходовНеНДС.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходовНеНДС);
		
	Если ЗначениеЗаполнено(Объект.СтатьяРасходовНеНДС) Тогда
		СтатьяРасходовНеНДСПриИзмененииНаСервере();
	Иначе
		АналитикаРасходовНеНДСОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовНеНДСПриИзмененииНаСервере()
	
	АналитикаРасходовНеНДСОбязательна = 
		ЗначениеЗаполнено(Объект.СтатьяРасходовНеНДС)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходовНеНДС, "КонтролироватьЗаполнениеАналитики");
		
	АналитикаРасходовЗаказРеализацияНеНДС = 
		ЗначениеЗаполнено(Объект.СтатьяРасходовНеНДС)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходовНеНДС, "АналитикаРасходовЗаказРеализация");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовЕНВДПриИзменении(Элемент)
	
	Элементы.АналитикаРасходовЕНВД.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходовЕНВД);
	
	Если ЗначениеЗаполнено(Объект.СтатьяРасходовЕНВД) Тогда
		СтатьяРасходовЕНВДПриИзмененииНаСервере();
	Иначе
		АналитикаРасходовЕНВДОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовЕНВДПриИзмененииНаСервере()
	
	АналитикаРасходовЕНВДОбязательна = 
		ЗначениеЗаполнено(Объект.СтатьяРасходовЕНВД)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходовЕНВД, "КонтролироватьЗаполнениеАналитики");
		
	АналитикаРасходовЗаказРеализацияЕНВД = 
		ЗначениеЗаполнено(Объект.СтатьяРасходовЕНВД)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходовЕНВД, "АналитикаРасходовЗаказРеализация");
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНеНДСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если АналитикаРасходовЗаказРеализацияНеНДС Тогда
		ПродажиКлиент.НачалоВыбораАналитикиРасходов(Элемент, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНеНДСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Объект.АналитикаРасходовНеНДС = ВыбранноеЗначение.АналитикаРасходов;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНеНДСАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНеНДСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовЕНВДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если АналитикаРасходовЗаказРеализацияЕНВД Тогда
		ПродажиКлиент.НачалоВыбораАналитикиРасходов(Элемент, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовЕНВДОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Объект.АналитикаРасходовЕНВД = ВыбранноеЗначение.АналитикаРасходов;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовЕНВДАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовЕНВДОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВариантОпределенияБазыРаспределенияНДСПриИзменении(Элемент)
	
	ВариантОпределенияБазыРаспределенияНДСПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура БазаВыручкаНДС0СырьевыеТоварыУслугиПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьБазуРаспределенияПоВыручкеСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьДанныеПоВыручкеСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура АнализРаспределенияНДС(Команда)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("Организация", Объект.Организация);
	СтруктураПараметров.Вставить("Период",      Объект.Дата);
	СтруктураПараметров.Вставить("Документ",    Объект.Ссылка);
	ОткрытьФорму("Отчет.АнализРаспределенияНДС.Форма", СтруктураПараметров);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПродажиСервер.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	РеквизитыПроверкиАналитик = Новый Массив;
	РеквизитыПроверкиАналитик.Добавить("СтатьяРасходовНеНДС, АналитикаРасходовНеНДС, СтатьяРасходовЕНВД, АналитикаРасходовЕНВД");
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление, РеквизитыПроверкиАналитик);
	
КонецПроцедуры

#Область Прочее

&НаКлиенте
Процедура ВариантПримененияПравила5ПроцентовПриИзменении(Элемент)
	
	ВариантПримененияПравила5ПроцентовПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПояснениеПримененияПорога5Процентов()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) ИЛИ НЕ УчитыватьПорог5Процентов Тогда
		Элементы.ГруппаПояснениеПримененияПравила5Процентов.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаПояснениеПримененияПравила5Процентов.Видимость = Истина;
	
	Состояние = УниверсальныеМеханизмыПартийИСебестоимости.ТекущееСостояниеРасчета(Объект.Дата, Объект.Организация);
	
	Если Состояние = Перечисления.СостоянияОперацийЗакрытияМесяца.ВыполненоСОшибками
	 ИЛИ Состояние = Перечисления.СостоянияОперацийЗакрытияМесяца.НеВыполнено Тогда
		
		КартинкаПояснение = БиблиотекаКартинок.Информация;
		ТекстПояснения = НСтр("ru = 'Расчет себестоимости не выполнен, решение следует принять на основании предварительной оценки.'");
		
	Иначе
		
		Оценка = Документы.РаспределениеНДС.ОценкаПримененияПравила5Процентов(Объект.Организация, Объект.Дата); // в таблице должна быть только одна строка
		
		Если Оценка.Количество() <> 1 Тогда
			
			Элементы.ГруппаПояснениеПримененияПравила5Процентов.Видимость = Ложь;
			Возврат;
			
		ИначеЕсли Оценка[0].РасходыПоДеятельностиНеОблагаемойНДС = 0 Тогда
			
			Если НЕ Объект.ПрименитьПравило5Процентов Тогда
				КартинкаПояснение = БиблиотекаКартинок.Внимание16;
			Иначе
				КартинкаПояснение = БиблиотекаКартинок.Информация;
			КонецЕсли;
			
			ТекстПояснения = НСтр("ru = 'Отсутствуют расходы по реализации, не облагаемой НДС. Весь НДС может быть принят к вычету.'");
			
		Иначе
			
			Если НЕ Объект.ПрименитьПравило5Процентов И Оценка[0].Доля <= 5 Тогда
				КартинкаПояснение = БиблиотекаКартинок.Внимание16;
				ШаблонПояснения =
					НСтр("ru = 'Расходы по реализациии, не облагаемой НДС (%1 %2), составляют %4% от общих расходов (%3 %2). 
								|Весь НДС может быть принят к вычету.'");
			ИначеЕсли Объект.ПрименитьПравило5Процентов И Оценка[0].Доля > 5 Тогда
				КартинкаПояснение = БиблиотекаКартинок.ВниманиеКрасный;
				ШаблонПояснения =
					НСтр("ru = 'Расходы по реализациии, не облагаемой НДС (%1 %2), составляют %4% от общих расходов (%3 %2). 
								|НДС должен быть распределен между видами деятельности.'");
			Иначе
				КартинкаПояснение = БиблиотекаКартинок.Информация;
				ШаблонПояснения = НСтр("ru = 'Расходы по реализациии, не облагаемой НДС (%1 %2), составляют %4% от общих расходов (%3 %2).'");
			КонецЕсли;
			
			ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонПояснения,  
				Оценка[0].РасходыПоДеятельностиНеОблагаемойНДС,
				ВалютаРегламентированногоУчета,
				Оценка[0].РасходыВсего,
				Формат(Оценка[0].Доля, "ЧДЦ=2"));
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВариантПримененияПравила5ПроцентовПриИзмененииСервер()
	
	Объект.ПрименитьПравило5Процентов = ?(ВариантПримененияПравила5Процентов = 1, Истина, Ложь);
	УправлениеЭлементамиФормы();
	СформироватьПояснениеПримененияПорога5Процентов();
	
КонецПроцедуры

&НаСервере
Процедура ВариантОпределенияБазыРаспределенияНДСПриИзмененииСервер()
	
	Объект.БазаРаспределенияУстанавливаетсяВручную = 
		?(ВариантОпределенияБазыРаспределенияНДС = 1, Истина, Ложь);
		
	Если Объект.БазаРаспределенияУстанавливаетсяВручную Тогда
		ЗаполнитьБазуРаспределенияПоВыручкеСервер();
	Иначе
		ОбновитьДанныеПоВыручкеСервер();
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ИнициализацияИЗаполнение

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПараметрыУчетнойПолитики = РегистрыСведений.УчетнаяПолитикаОрганизаций.ПараметрыУчетнойПолитики(Объект.Организация, Объект.Дата);
	Если ПараметрыУчетнойПолитики <> Неопределено Тогда
		ПрименяетсяЕНВД = ПараметрыУчетнойПолитики.ПрименяетсяЕНВД;
		УчитыватьПорог5Процентов = ПараметрыУчетнойПолитики.Учитывать5ПроцентныйПорог;
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ИспользуетсяУчетПрочихДоходовРасходов = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов");
	
	ВариантПримененияПравила5Процентов = ?(Объект.ПрименитьПравило5Процентов, 1, 0);
	ВариантОпределенияБазыРаспределенияНДС = ?(Объект.БазаРаспределенияУстанавливаетсяВручную, 1, 0);
	
	СформироватьПояснениеПримененияПорога5Процентов();
	
	Если НЕ Объект.БазаРаспределенияУстанавливаетсяВручную Тогда
		ОбновитьДанныеПоВыручкеСервер();
	КонецЕсли;
	
	СтатьяРасходовНеНДСПриИзмененииНаСервере();
	СтатьяРасходовЕНВДПриИзмененииНаСервере();
	
	Элементы.АналитикаРасходовНеНДС.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходовНеНДС);
	Элементы.АналитикаРасходовЕНВД.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходовЕНВД);
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	ЭтоКонецКвартала = (Месяц(Объект.Дата)%3 = 0);
	
	Элементы.ГруппаПрименениеПравила5Процентов.Видимость = УчитыватьПорог5Процентов И ЭтоКонецКвартала;
	Элементы.ПараметрыРаспределениеНДС.Доступность = (НЕ ЭтоКонецКвартала) ИЛИ (НЕ Объект.ПрименитьПравило5Процентов);
	
	УпрощенныйПорядокВычетаНДСПоНесырьевомуЭкспорту = УчетНДСУТ.УпрощенныйПорядокВычетаНДСПоНесырьевомуЭкспорту(Объект.Дата);
	
	Элементы.ВыручкаНДС0.Видимость = НЕ УпрощенныйПорядокВычетаНДСПоНесырьевомуЭкспорту;
	Элементы.БазаВыручкаНДС0.Видимость = НЕ УпрощенныйПорядокВычетаНДСПоНесырьевомуЭкспорту;
	
	ПоказыватьЭкспортНесырьевыхТоваров = 
		УпрощенныйПорядокВычетаНДСПоНесырьевомуЭкспорту И ПолучитьФункциональнуюОпцию("ИспользоватьПродажиНаЭкспортНесырьевыхТоваров");
	Элементы.ВыручкаНДС0НесырьевыеТовары.Видимость = ПоказыватьЭкспортНесырьевыхТоваров;
	Элементы.БазаВыручкаНДС0НесырьевыеТовары.Видимость = ПоказыватьЭкспортНесырьевыхТоваров;
	
	ПоказыватьЭкспортСырьевыхТоваровУслуг = 
		УпрощенныйПорядокВычетаНДСПоНесырьевомуЭкспорту И ПолучитьФункциональнуюОпцию("ИспользоватьПродажиНаЭкспортСырьевыхТоваровУслуг");
	Элементы.ГруппаВыручкаНДС0СырьевыеТоварыУслуги.Видимость = ПоказыватьЭкспортСырьевыхТоваровУслуг;
	Элементы.ГруппаБазаВыручкаНДС0СырьевыеТоварыУслуги.Видимость = ПоказыватьЭкспортСырьевыхТоваровУслуг;
	
	ШаблонЗаголовка = НСтр("ru = 'Документы экспорта сырьевых товаров, работ, услуг (%1)'");
	ТекстЗаголовка = НСтр("ru = 'Документы экспорта сырьевых товаров, работ, услуг'");
	Если Объект.ДокументыЭкспорт.Количество() <> 0 Тогда
		Элементы.БазаДокументыЭкспорт.Заголовок = СтрШаблон(ШаблонЗаголовка, Объект.ДокументыЭкспорт.Количество());
	Иначе
		Элементы.БазаДокументыЭкспорт.Заголовок = ТекстЗаголовка;
	КонецЕсли;
	
	Если ДокументыЭкспорт.Количество() <> 0 Тогда
		Элементы.ДокументыЭкспорт.Заголовок = СтрШаблон(ШаблонЗаголовка, ДокументыЭкспорт.Количество());
		Элементы.ДокументыЭкспорт.Доступность = Истина;
	Иначе
		Элементы.ДокументыЭкспорт.Заголовок = ТекстЗаголовка;
		Элементы.ДокументыЭкспорт.Доступность = Ложь;
	КонецЕсли;
	
	Если НЕ Объект.ПрименитьПравило5Процентов Тогда
		
		Элементы.ГруппаБазаРаспределения.ТекущаяСтраница = 
			?(Объект.БазаРаспределенияУстанавливаетсяВручную,
				Элементы.ГруппаБазаУказанаВручную,
				Элементы.ГруппаБазаУказанаАвтоматически);
		Элементы.БазаВыручкаЕНВД.ТолькоПросмотр = НЕ ПрименяетсяЕНВД;
		
		НеобходимоРаспределениеНДСПоТоварам = Документы.РаспределениеНДС.НеобходимоРаспределениеНДСПоТоварам(Объект.Организация, Объект.Дата);
		
		ЗначениеВыручкаНеНДС = ?(ВариантОпределенияБазыРаспределенияНДС = 0, ВыручкаНеНДС, Объект.ВыручкаНеНДС);
		ЗначениеВыручкаЕНВД = ?(ВариантОпределенияБазыРаспределенияНДС = 0, ВыручкаЕНВД, Объект.ВыручкаЕНВД);
		
		ТребуетсяЗаполнение = (ЗначениеВыручкаНеНДС <> 0)
			И (НеобходимоРаспределениеНДСПоТоварам ИЛИ НЕ Объект.СписатьНДСПоРасходамАктивамНаСтатьиОтражения);
		Элементы.СтатьяЗатратНеНДС.АвтоОтметкаНезаполненного = ТребуетсяЗаполнение;
		Если Не ТребуетсяЗаполнение И Элементы.СтатьяЗатратНеНДС.ОтметкаНезаполненного Тогда
			Элементы.СтатьяЗатратНеНДС.ОтметкаНезаполненного = Ложь;
		КонецЕсли;
		
		ТребуетсяЗаполнение =  (ЗначениеВыручкаЕНВД <> 0)
			И (НеобходимоРаспределениеНДСПоТоварам ИЛИ НЕ Объект.СписатьНДСПоРасходамАктивамНаСтатьиОтражения);
		Элементы.СтатьяЗатратЕНВД.АвтоОтметкаНезаполненного = ТребуетсяЗаполнение;
		Если Не ТребуетсяЗаполнение И Элементы.СтатьяЗатратЕНВД.ОтметкаНезаполненного Тогда
			Элементы.СтатьяЗатратЕНВД.ОтметкаНезаполненного = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	ПравилаСписания = Документы.РаспределениеНДС.ЗаполнитьПравилаСписанияНДС(Объект.Организация);
	ЗаполнитьЗначенияСвойств(Объект,ПравилаСписания);
	
	ПараметрыУчетнойПолитики = РегистрыСведений.УчетнаяПолитикаОрганизаций.ПараметрыУчетнойПолитики(Объект.Организация, Объект.Дата);
	Если ПараметрыУчетнойПолитики <> Неопределено Тогда
		ПрименяетсяЕНВД = ПараметрыУчетнойПолитики.ПрименяетсяЕНВД;
		УчитыватьПорог5Процентов = ПараметрыУчетнойПолитики.Учитывать5ПроцентныйПорог;
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	СформироватьПояснениеПримененияПорога5Процентов();
	
КонецПроцедуры

&НаСервере
Процедура ПериодПриИзмененииСервер()
	
	ПараметрыУчетнойПолитики = РегистрыСведений.УчетнаяПолитикаОрганизаций.ПараметрыУчетнойПолитики(Объект.Организация, Объект.Дата);
	Если ПараметрыУчетнойПолитики <> Неопределено Тогда
		ПрименяетсяЕНВД = ПараметрыУчетнойПолитики.ПрименяетсяЕНВД;
		УчитыватьПорог5Процентов = ПараметрыУчетнойПолитики.Учитывать5ПроцентныйПорог;
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	СформироватьПояснениеПримененияПорога5Процентов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНадписьПериод()
	
	ПредставлениеПериода = ПредставлениеПериода(НачалоМесяца(Объект.Дата), КонецМесяца(Объект.Дата), "ДЛФ=D");
	Если Месяц(Объект.Дата)%3=0 Тогда
		ПредставлениеПериода = ПредставлениеПериода(НачалоКвартала(Объект.Дата), КонецКвартала(Объект.Дата), "ДЛФ=D");
	КонецЕсли;
	
	НадписьПериод = ПредставлениеПериода;
	
КонецПроцедуры

#КонецОбласти

#Область Автозаполнение

&НаСервере
Процедура ЗаполнитьБазуРаспределенияПоВыручкеСервер()
	
	Результат = Документы.РаспределениеНДС.ПолучитьБазуРаспределения(Объект.Дата, Объект.Организация);
	
	ЗаполнитьЗначенияСвойств(
		Объект, 
		Результат, 
		"ВыручкаНДС, ВыручкаНеНДС, ВыручкаЕНВД, ВыручкаНДС0, ВыручкаНДС0НесырьевыеТовары, ВыручкаНДС0СырьевыеТоварыУслуги");
		
		
	Объект.ДокументыЭкспорт.Загрузить(Результат.ДокументыЭкспорт);
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеПоВыручкеСервер()
	
	Результат = Документы.РаспределениеНДС.ПолучитьБазуРаспределения(Объект.Дата, Объект.Организация);
	
	ЗаполнитьЗначенияСвойств(
		ЭтаФорма, 
		Результат, 
		"ВыручкаНДС, ВыручкаНеНДС, ВыручкаЕНВД, ВыручкаНДС0, ВыручкаНДС0НесырьевыеТовары, ВыручкаНДС0СырьевыеТоварыУслуги");
		
	ДокументыЭкспорт.Загрузить(Результат.ДокументыЭкспорт);
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьДокументыЭкспорт(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресВременногоХранилища", ПоместитьБазаДокументыЭкспортВоВременноеХранилище());
	ПараметрыФормы.Вставить("РежимРедактирования", Истина);
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ФормаДокументыЭкспортЗакрытие", ЭтотОбъект);
	ОткрытьФорму("Документ.РаспределениеНДС.Форма.ФормаДокументыЭкспорт", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьБазаДокументыЭкспортВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ДокументыЭкспорт.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ФормаДокументыЭкспортЗакрытие(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ФормаДокументыЭкспортЗакрытиеСервер(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ФормаДокументыЭкспортЗакрытиеСервер(АдресВременногоХранилища)
	
	Объект.ДокументыЭкспорт.Загрузить(ПолучитьИзВременногоХранилища(АдресВременногоХранилища));
	Объект.ВыручкаНДС0СырьевыеТоварыУслуги = Объект.ДокументыЭкспорт.Итог("СуммаВыручки") + Объект.ДокументыЭкспорт.Итог("КорректировкаВыручки");
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПосмотретьДокументыЭкспорт(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресВременногоХранилища", ПоместитьДокументыЭкспортВоВременноеХранилище());
	ПараметрыФормы.Вставить("РежимРедактирования", Ложь);
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	
	ОткрытьФорму("Документ.РаспределениеНДС.Форма.ФормаДокументыЭкспорт", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьДокументыЭкспортВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(ДокументыЭкспорт.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти

#КонецОбласти
