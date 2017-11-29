﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
		
	УстановитьЗначенияПоПараметрамФормы(Параметры);
	ОбновитьДанныеФормы();
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.СписокГруппаКоманднаяПанельГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(Отказ, СтандартнаяОбработка, ПараметрыПриСозданииНаСервере);
	// Конец подсистема "ОбменСКонтрагентами".
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	
	Если Не ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.СодержитНекоректныхКонтрагентов.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
	// Подсистема "ОбменСКонтрагентами".
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец подсистема "ОбменСКонтрагентами".

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец подсистема "ОбменСКонтрагентами".
	
	Если ИмяСобытия = "Запись_СчетФактураКомиссионера" Тогда
		Элементы.КОформлению.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КОформлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Значение = Неопределено;
	
	Если Поле = Элементы.КОформлениюОрганизация Тогда
		Значение = Элемент.ТекущиеДанные.Организация;
	ИначеЕсли Поле = Элементы.КОформлениюКомиссионер Тогда
		Значение = Элемент.ТекущиеДанные.Комиссионер;
	ИначеЕсли Поле = Элементы.КОформлениюОтчетКомиссионера Тогда
		Значение = Элемент.ТекущиеДанные.ОтчетКомиссионера;
	КонецЕсли; 
	
	Если Значение <> Неопределено Тогда
		ПоказатьЗначение(, Значение);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КомиссионерПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.ГруппаВыданныеСчетаФактуры Тогда
		Элементы.Список.Обновить();
	ИначеЕсли ТекущаяСтраница = Элементы.ГруппаКОформлению Тогда
		Элементы.КОформлению.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоПериода, КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСчетаФактуры(Команда)
	
	Результат = СформироватьСчетаФактурыСервер();
	
	Оповестить("Запись_СчетФактураКомиссионера", , Результат);
	
	Элементы.Список.Обновить();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыданныеСчетаФактуры;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.СчетФактураКомиссионеру.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(,МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Функция СформироватьСчетаФактурыСервер()
	
	Результат = Новый Массив;
	
	ФормироватьСводныеСФ = (ВариантФормированияСчетовФактур = 1);
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КОформлению.ОтчетКомиссионера КАК ОтчетКомиссионера,
	|	КОформлению.Организация КАК Организация,
	|	КОформлению.Комиссионер КАК Комиссионер,
	|	КОформлению.Покупатель,
	|	КОформлению.НомерСчетаФактуры КАК НомерСчетаФактуры,
	|	КОформлению.ДатаСчетаФактуры  КАК ДатаСчетаФактуры
	|ПОМЕСТИТЬ КОформлению
	|ИЗ
	|	РегистрСведений.СчетаФактурыКомиссионерамКОформлению КАК КОформлению
	|ГДЕ
	|	(КОформлению.ДатаСчетаФактуры >= &НачалоПериода ИЛИ &НачалоПериода = &ПустаяДата)
	|	И (КОформлению.ДатаСчетаФактуры <= &КонецПериода ИЛИ &КонецПериода = &ПустаяДата)
	|	И (&ВсеОрганизации ИЛИ КОформлению.Организация = &Организация)
	|	И (&ВсеКомиссионеры ИЛИ КОформлению.Комиссионер = &Комиссионер)
	|;
	|
	|///////////////////////////////////////////////////////////////////////1
	|
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(ИсторияКППКонтрагентов.Период) КАК Период,
	|	ИсторияКППКонтрагентов.Ссылка           КАК Ссылка
	|ПОМЕСТИТЬ ЗначенияКПП
	|ИЗ
	|	Справочник.Контрагенты.ИсторияКПП КАК ИсторияКППКонтрагентов
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ КОформлению
	|	ПО ИсторияКППКонтрагентов.Ссылка = КОформлению.Покупатель
	|		И ИсторияКППКонтрагентов.Период <= КОформлению.ДатаСчетаФактуры
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсторияКППКонтрагентов.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////2
	|
	|ВЫБРАТЬ
	|	ИсторияКППКонтрагентов.КПП    КАК КПП,
	|	ИсторияКППКонтрагентов.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ИсторическоеЗначениеКПП
	|ИЗ
	|	ЗначенияКПП КАК ЗначенияКПП
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты.ИсторияКПП КАК ИсторияКППКонтрагентов
	|		ПО ЗначенияКПП.Ссылка = ИсторияКППКонтрагентов.Ссылка
	|			И ЗначенияКПП.Период = ИсторияКППКонтрагентов.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////3
	|
	|ВЫБРАТЬ
	|	Покупатели.ОтчетКомиссионера                                           КАК ДокументОснование,
	|	Покупатели.Организация                                                 КАК Организация,
	|	Покупатели.Покупатель                                                  КАК Покупатель,
	|	ЕСТЬNULL(ЕСТЬNULL(ИсторическоеЗначениеКПП.КПП, Контрагенты.КПП), """") КАК КПППокупателя,
	|	ЕСТЬNULL(Контрагенты.ИНН, """")                                        КАК ИННПокупателя,
	|	Покупатели.НомерСчетаФактуры                                           КАК НомерСчетаФактуры,
	|	Покупатели.ДатаСчетаФактуры                                            КАК ДатаСчетаФактуры
	|ИЗ
	|	КОформлению КАК Покупатели
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
	|			ПО Контрагенты.Ссылка = Покупатели.Покупатель
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИсторическоеЗначениеКПП КАК ИсторическоеЗначениеКПП
	|			ПО ИсторическоеЗначениеКПП.Ссылка = Контрагенты.Ссылка
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////4
	|
	|ВЫБРАТЬ
	|	СчетаФактуры.ОтчетКомиссионера КАК ДокументОснование,
	|	ВЫБОР 
	|		КОГДА СчетаФактуры.ДатаСчетаФактуры = ДАТАВРЕМЯ(1,1,1)
	|			ТОГДА СчетаФактуры.ОтчетКомиссионера.Дата
	|		ИНАЧЕ СчетаФактуры.ДатаСчетаФактуры
	|	КОНЕЦ КАК Дата,
	|	СчетаФактуры.Организация КАК Организация,
	|	СчетаФактуры.Комиссионер КАК Комиссионер,
	|	СчетаФактуры.ДатаСчетаФактуры  КАК ДатаСчетаФактуры,
	|	СчетаФактуры.Покупатель КАК Покупатель,
	|	СчетаФактуры.НомерСчетаФактуры КАК НомерСчетаФактуры
	|ИЗ
	|	КОформлению КАК СчетаФактуры
	|ГДЕ
	|	НЕ &ФормироватьСводныеСФ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СчетаФактуры.ОтчетКомиссионера КАК ДокументОснование,
	|	ВЫБОР 
	|		КОГДА СчетаФактуры.ДатаСчетаФактуры = ДАТАВРЕМЯ(1,1,1)
	|			ТОГДА СчетаФактуры.ОтчетКомиссионера.Дата
	|		ИНАЧЕ СчетаФактуры.ДатаСчетаФактуры
	|	КОНЕЦ КАК Дата,
	|	СчетаФактуры.Организация КАК Организация,
	|	СчетаФактуры.Комиссионер КАК Комиссионер,
	|	СчетаФактуры.ДатаСчетаФактуры КАК ДатаСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК Покупатель,
	|	НЕОПРЕДЕЛЕНО КАК НомерСчетаФактуры
	|ИЗ
	|	КОформлению КАК СчетаФактуры
	|ГДЕ
	|	&ФормироватьСводныеСФ
	|";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ФормироватьСводныеСФ", ФормироватьСводныеСФ);
	Запрос.УстановитьПараметр("Организация",          Организация);
	Запрос.УстановитьПараметр("ВсеОрганизации",       НЕ ЗначениеЗаполнено(Организация));
	Запрос.УстановитьПараметр("Комиссионер",          Комиссионер);
	Запрос.УстановитьПараметр("ВсеКомиссионеры",      НЕ ЗначениеЗаполнено(Комиссионер));
	Запрос.УстановитьПараметр("НачалоПериода",        НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",         КонецПериода);
	Запрос.УстановитьПараметр("ПустаяДата",           Дата(1,1,1));
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	Покупатели = РезультатЗапроса[3].Выгрузить();
	Покупатели.Индексы.Добавить("ДокументОснование, Организация, ДатаСчетаФактуры, Покупатель, НомерСчетаФактуры");
	
	Выборка = РезультатЗапроса[4].Выбрать();
	ДанныеЗаполнения = Новый Структура;
	Для Каждого Колонка Из РезультатЗапроса[4].Колонки Цикл
		ДанныеЗаполнения.Вставить(Колонка.Имя);
	КонецЦикла;

	Пока Выборка.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, Выборка);
		
		НовыйСчетФактура = Документы.СчетФактураКомиссионеру.СоздатьДокумент();
		
		Отбор = Новый Структура;
		Отбор.Вставить("ДокументОснование");
		Отбор.Вставить("Организация");
		Отбор.Вставить("ДатаСчетаФактуры");
		Если НЕ ФормироватьСводныеСФ Тогда
			Отбор.Вставить("Покупатель");
			Отбор.Вставить("НомерСчетаФактуры");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(Отбор, Выборка);
		
		СтрокиПокупатели = Покупатели.НайтиСтроки(Отбор);
		Для каждого Строка Из СтрокиПокупатели Цикл
			НоваяСтрока = НовыйСчетФактура.Покупатели.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		КонецЦикла;
		
		ВыставляемыйСФ = Ложь;
		Для каждого Строка Из НовыйСчетФактура.Покупатели Цикл
			Если Строка.Покупатель <> Справочники.Контрагенты.РозничныйПокупатель ИЛИ Строка.НомерСчетаФактуры <> "" Тогда
				ВыставляемыйСФ = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ВыставляемыйСФ Тогда 
			ДанныеЗаполнения.Вставить("ДатаВыставления", ДанныеЗаполнения.Дата);
		КонецЕсли;

		НовыйСчетФактура.Заполнить(ДанныеЗаполнения);
		
		Попытка
			НовыйСчетФактура.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ТекстОшибки = НСтр("ru='Не удалось записать %Документ%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%",       НовыйСчетФактура);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки, , ,);
		КонецПопытки;
		
		Результат.Добавить(НовыйСчетФактура.Ссылка);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, РезультатВыбора, "НачалоПериода, КонецПериода");
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФормы()
	
	ЭлементыОрганизация = Новый Массив;
	ЭлементыОрганизация.Добавить("СписокОрганизация");
	ЭлементыОрганизация.Добавить("КОформлениюОрганизация");
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(
		Элементы, ЭлементыОрганизация, "Видимость", НЕ ЗначениеЗаполнено(Организация));
		
	ЭлементыОрганизация = Новый Массив;
	ЭлементыОрганизация.Добавить("СписокКомиссионер");
	ЭлементыОрганизация.Добавить("КОформлениюКомиссионер");
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(
		Элементы, ЭлементыОрганизация, "Видимость", НЕ ЗначениеЗаполнено(Комиссионер));

	ДинамическиеСписки = Новый Массив;
	ДинамическиеСписки.Добавить("Список");
	ДинамическиеСписки.Добавить("КОформлению");
	
	Для каждого Имя Из ДинамическиеСписки Цикл
		
		ЭлементыОтбора = ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(ЭтаФорма[Имя]).Элементы;
		
		ГруппаОтбораПериода = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
			ЭлементыОтбора, "ГруппаОтбораПериода", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ЭтаФорма[Имя], 
			"Комиссионер", 
			Комиссионер, 
			ВидСравненияКомпоновкиДанных.Равно
			,
			,
			ЗначениеЗаполнено(Комиссионер));
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ЭтаФорма[Имя], 
			"Организация", 
			Организация, 
			ВидСравненияКомпоновкиДанных.Равно
			,
			,
			ЗначениеЗаполнено(Организация));
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаОтбораПериода,
			"Дата", 
			ВидСравненияКомпоновкиДанных.БольшеИлиРавно, 
			НачалоДня(НачалоПериода),
			,
			ЗначениеЗаполнено(НачалоПериода));
			
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаОтбораПериода,
			"Дата", 
			ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, 
			КонецДня(КонецПериода),
			,
			ЗначениеЗаполнено(КонецПериода));
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоПараметрамФормы(Параметры)
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("НачалоПериода", НачалоПериода);
		СтруктураБыстрогоОтбора.Свойство("КонецПериода", КонецПериода);
	КонецЕсли;
	Если Параметры.Свойство("ОтображатьСтраницуКОформлению") Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаКОформлению;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
