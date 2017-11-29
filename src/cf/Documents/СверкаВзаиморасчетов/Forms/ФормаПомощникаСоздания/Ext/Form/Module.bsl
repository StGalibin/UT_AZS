﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ИнициализироватьКомпоновщикНастроек();
	
	ПериодСверки.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяц;
	
	ДатаДокументов = ТекущаяДатаСеанса();
	
	ДоступноСохранениеДанныхПользователя = ПравоДоступа("СохранениеДанныхПользователя", Метаданные);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	             ЭтотОбъект, "ГруппаОтбор", НСтр("ru = 'Отбор по организациям и контрагентам:'"));
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	             ЭтотОбъект, "РасчетыСПартнерами", НСтр("ru = 'Открыть отчет ""Расчеты с контрагентами"":'"));

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановкаДоступностиЭлементовФормы();
	
	УправлениеКнопкамиПодвал();
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Документ.СверкаВзаиморасчетов.Форма.ФормаПомощникаСоздания",
													 "КомпоновщикОтборПользовательскиеНастройки",
													 КомпоновщикОтбор.ПользовательскиеНастройки);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ПользовательскиеНастройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Документ.СверкаВзаиморасчетов.Форма.ФормаПомощникаСоздания",
													 							  "КомпоновщикОтборПользовательскиеНастройки");
																				   
	Если ПользовательскиеНастройки <> Неопределено Тогда
		КомпоновщикОтбор.ЗагрузитьПользовательскиеНастройки(ПользовательскиеНастройки);
	КонецЕсли;																				   

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ЗадаватьВопросОЗакрытии Тогда
		
		ТекстВопроса = НСтр("ru = 'Закрыть форму помощника? Введенные данные будут потеряны.'");
		Отказ = Истина;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗадаватьВопросОЗакрытии = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДетализацияВзаиморасчетовНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Партнер", Партнер);
	СтруктураПараметров.Вставить("РасшифровкаПоЗаказам", РасшифровкаПоЗаказам);
	СтруктураПараметров.Вставить("РасшифровкаПоПартнерам", РасшифровкаПоПартнерам);
	СтруктураПараметров.Вставить("РасшифровкаПоДоговорам", РасшифровкаПоДоговорам);
	
	ОткрытьФорму("Документ.СверкаВзаиморасчетов.Форма.ФормаНастройкиДетализации", СтруктураПараметров,,,,, 
		Новый ОписаниеОповещения("ДетализацияВзаиморасчетовНажатиеЗавершение", ЭтотОбъект), 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ДетализацияВзаиморасчетовНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    // Обработка результата
    Если ТипЗнч(Результат) = Тип("Структура") Тогда
        Партнер = Результат.Партнер;
        РасшифровкаПоЗаказам = Результат.РасшифровкаПоЗаказам;
        РасшифровкаПоПартнерам = Результат.РасшифровкаПоПартнерам;
        РасшифровкаПоДоговорам = Результат.РасшифровкаПоДоговорам;
    КонецЕсли;
    
    ДетализацияВзаиморасчетов = ПредставлениеДетализацииВзаиморасчетов();

КонецПроцедуры

&НаКлиенте
Процедура ПериодСверкиВариантПриИзменении(Элемент)
	
	УстановкаДоступностиЭлементовФормы();
		
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьДокументыНаПечатьПриИзменении(Элемент)
	
	УстановкаДоступностиЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантДетализацииВзаиморасчетовПриИзменении(Элемент)
	
	Элементы.ДетализацияВзаиморасчетов.Доступность = ВариантДетализацииВзаиморасчетов = 1;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицарасчетов

&НаКлиенте
Процедура ТаблицаРасчетовСоздаватьДокументПриИзменении(Элемент)
	
	ПересчитатьКоличествоСтрокТаблицыРасчетов();
	ЗадаватьВопросОЗакрытии = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРасчетовОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРасчетовКонтрагентНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРасчетовОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРасчетовКонтрагентОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
    ВыполнитьПереходПоСтраницам(Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ВыполнитьПереходПоСтраницам(Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ВыполнитьПереходПоСтраницам(Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	СоздаватьДокументыДляВсехСтрок(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	СоздаватьДокументыДляВсехСтрок(Ложь);	
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыСПартнерами(Команда)
	
	ОчиститьСообщения();
	
	ПараметрыФормы = Новый Структура("Отбор, ФиксированныеНастройки, КлючВарианта, СформироватьПриОткрытии");
	ПараметрыФормы.СформироватьПриОткрытии = Истина;
	
	ПараметрыФормы.Отбор = Новый Структура("Период", ПериодСверки);
	
	Если Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаНастройкаФильтров Тогда
		
		ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных();
		
		Для Каждого ЭлементОтбора Из КомпоновщикОтбор.Настройки.Отбор.Элементы Цикл
			
			ПользНастройкаОтбора = КомпоновщикОтбор.ПользовательскиеНастройки.Элементы.Найти(ЭлементОтбора.ИдентификаторПользовательскойНастройки);
			Если ПользНастройкаОтбора.Использование Тогда
				
				ПараметрыФормы.Отбор.Вставить(ЭлементОтбора.ЛевоеЗначение, ПользНастройкаОтбора.ПравоеЗначение);
				
			КонецЕсли;
			
		КонецЦикла;
		
		ПараметрыФормы.ФиксированныеНастройки = ФиксированныеНастройки;
		
	ИначеЕсли Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаТаблицаРасчетов Тогда
		
		Если Элементы.ТаблицаРасчетов.ТекущиеДанные = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбрана ни одна строка'"),,"ТаблицаРасчетов");
			Возврат;
		КонецЕсли;
		
		ПараметрыФормы.Отбор.Вставить("Организация", Элементы.ТаблицаРасчетов.ТекущиеДанные.Организация);
		ПараметрыФормы.Отбор.Вставить("Контрагент",  Элементы.ТаблицаРасчетов.ТекущиеДанные.Контрагент);
		
	КонецЕсли;
	
	ПараметрыФормы.КлючВарианта = "ПоСверкеВзаиморасчетовКонтекст";
	
	ОткрытьФорму("Отчет.РасчетыСПартнерами.Форма",
		ПараметрыФормы,
		ЭтаФорма,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиПервогоШагаПомощника

&НаСервере
Процедура ЗаполнитьТаблицуРасчетовСервер()

	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСКлиентамиОбороты.АналитикаУчетаПоПартнерам   КАК АналитикаУчетаПоПартнерам
	|ПОМЕСТИТЬ Обороты
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами.Обороты(&НачалоПериодаСверки,
	|												&КонецПериодаСверки,
	|												Период,
	|												АналитикаУчетаПоПартнерам В (&АналитикаУчетаПоПартнерам)
	|												) КАК РасчетыСКлиентамиОбороты
	|ГДЕ РасчетыСКлиентамиОбороты.СуммаПриход <> 0 ИЛИ РасчетыСКлиентамиОбороты.СуммаРасход <> 0
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	РасчетыСПоставщикамиОбороты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками.Обороты(&НачалоПериодаСверки,
	|												&КонецПериодаСверки,
	|												Период,
	|												АналитикаУчетаПоПартнерам В (&АналитикаУчетаПоПартнерам)
	|												) КАК РасчетыСПоставщикамиОбороты
	|ГДЕ РасчетыСПоставщикамиОбороты.СуммаПриход <> 0 ИЛИ РасчетыСПоставщикамиОбороты.СуммаРасход <> 0
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	РасчетыСКлиентамиОстатки.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами.Остатки(&КонецПериодаСверки,
	|												АналитикаУчетаПоПартнерам В (&АналитикаУчетаПоПартнерам)
	|												) КАК РасчетыСКлиентамиОстатки
	|ГДЕ
	|	РасчетыСКлиентамиОстатки.СуммаОстаток <> 0
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	РасчетыСПоставщикамиОстатки.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками.Остатки(&КонецПериодаСверки,
	|												АналитикаУчетаПоПартнерам В (&АналитикаУчетаПоПартнерам)
	|												) КАК РасчетыСПоставщикамиОстатки
	|ГДЕ
	|	РасчетыСПоставщикамиОстатки.СуммаОстаток <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Аналитика.Организация						 КАК Организация,
	|	Аналитика.Контрагент						 КАК Контрагент,
	|	Документы.Ссылка							 КАК ДокументСсылка,
	|	ВЫБОР КОГДА Документы.Ссылка ЕСТЬ NULL ТОГДА
	|		ЛОЖЬ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ										 КАК СуществуютДокументы,
	|	ВЫБОР КОГДА Документы.Ссылка ЕСТЬ NULL ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ										 КАК СоздаватьДокумент
	|ИЗ
	|	Обороты КАК Обороты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Аналитика
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|			ПО Аналитика.Организация = Организации.Ссылка
	|
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.СверкаВзаиморасчетов КАК Документы
	|			ПО Аналитика.Организация 						 = Документы.Организация
	|				И Аналитика.Контрагент 						 = Документы.Контрагент
	|				И Документы.НачалоПериода					 = &НачалоПериодаСверки
	|				И КОНЕЦПЕРИОДА(Документы.КонецПериода, ДЕНЬ) = &КонецПериодаСверки
	|				И НЕ Документы.ПометкаУдаления
	|
	|		ПО Обороты.АналитикаУчетаПоПартнерам = Аналитика.КлючАналитики
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организация,
	|	Контрагент
	|";  

	Запрос.УстановитьПараметр("НачалоПериодаСверки",			  ПериодСверки.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериодаСверки",				  КонецДня(ПериодСверки.ДатаОкончания));
	Запрос.УстановитьПараметр("АналитикаУчетаПоПартнерам",		  ПолучитьАналитикуУчетаПоПартнерам());

	ТаблицаРезультатаЗапроса = Запрос.Выполнить().Выгрузить();
	
	ТаблицаСуществующихДокументов.Загрузить(ТаблицаРезультатаЗапроса);
	
	ТаблицаРезультатаЗапроса.Свернуть("Организация, Контрагент, СуществуютДокументы, СоздаватьДокумент");

	ТаблицаРасчетов.Загрузить(ТаблицаРезультатаЗапроса);

КонецПроцедуры

&НаСервере
Функция ПолучитьАналитикуУчетаПоПартнерам()
	
	СхемаКомпоновкиДанных = Документы.СверкаВзаиморасчетов.ПолучитьМакет("ПомощникСозданияОтбор");
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикОтбор);
	НастройкиКомпоновкиДанных = КомпоновщикОтбор.ПолучитьНастройки();
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТаблицаКонтрагентов = ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Возврат ТаблицаКонтрагентов.ВыгрузитьКолонку("АналитикаУчетаПоПартнерам");
	
КонецФункции

#КонецОбласти

#Область ОбработчикиВторогоШагаПомощника

&НаКлиенте
Процедура СоздаватьДокументыДляВсехСтрок(СоздаватьДокументы)
	
	Для Каждого СтрокаТаблицы Из ТаблицаРасчетов Цикл
		                                      
		СтрокаТаблицы.СоздаватьДокумент = СоздаватьДокументы;
		
	КонецЦикла;
	
	ПересчитатьКоличествоСтрокТаблицыРасчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьКоличествоСтрокТаблицыРасчетов()
	
	КоличествоСуществующихИОтмеченных = 0;
	КоличествоСуществующих 		      = 0;
	КоличествоОтмеченных 		      = 0;
	
	Для Каждого СтрокаТаблицыРасчетов Из ТаблицаРасчетов Цикл
		
		Если  СтрокаТаблицыРасчетов.СуществуютДокументы
			И СтрокаТаблицыРасчетов.СоздаватьДокумент Тогда
			
			КоличествоСуществующихИОтмеченных = КоличествоСуществующихИОтмеченных + 1;
			КоличествоСуществующих 		      = КоличествоСуществующих + 1;
			КоличествоОтмеченных 		      = КоличествоОтмеченных + 1;
			
		ИначеЕсли СтрокаТаблицыРасчетов.СуществуютДокументы Тогда
			
			КоличествоСуществующих = КоличествоСуществующих + 1;
			
		ИначеЕсли СтрокаТаблицыРасчетов.СоздаватьДокумент Тогда
			
			КоличествоОтмеченных = КоличествоОтмеченных + 1;
			
		КонецЕсли;
		
	КонецЦикла;

	ВсегоСтрок	 = ТаблицаРасчетов.Количество();
	ВыбраноСтрок = КоличествоОтмеченных;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТретьегоШагаПомощника

&НаКлиенте
Процедура СоздатьДокументы()

	СоздатьДокументыСервер();
	
	МассивДокументовДляПечати = Новый Массив;
	
	КоличествоСозданных = 0;
	
	Для Каждого СтрокаПротокола Из ТаблицаОбработанныхДокументов Цикл
		
		Если СтрокаПротокола.Действие = 0 Тогда // Создание
			
			ОповеститьОДействии(СтрокаПротокола.ДокументСсылка, НСтр("ru='Создание:'"));
			
			МассивДокументовДляПечати.Добавить(СтрокаПротокола.ДокументСсылка);
			
			КоличествоСозданных = КоличествоСозданных + 1;
			
		ИначеЕсли СтрокаПротокола.Действие = 1 Тогда // Пометка удаления установлена
			
			ОповеститьОДействии(СтрокаПротокола.ДокументСсылка, НСтр("ru='Пометка удаления установлена:'"));
			
		ИначеЕсли СтрокаПротокола.Действие = 2 Тогда // Перезаполнение
			
			ОповеститьОДействии(СтрокаПротокола.ДокументСсылка, НСтр("ru='Перезаполнение:'"));
			
			МассивДокументовДляПечати.Добавить(СтрокаПротокола.ДокументСсылка);
			
		КонецЕсли;
			
	КонецЦикла;

	Если ОбработкаВыполнена Тогда
		
		ТекстРезультата = НСтр("ru='Создано %КоличествоСозданных% из %КоличествоВсего% документов'");
		ТекстРезультата = СтрЗаменить(ТекстРезультата, "%КоличествоСозданных%", КоличествоСозданных);
		ТекстРезультата = СтрЗаменить(ТекстРезультата, "%КоличествоВсего%",     КоличествоОтмеченных);
		
		Элементы.ДекорацияРезультат.Заголовок = ТекстРезультата;
		
		ЗадаватьВопросОЗакрытии = Ложь;
		
	КонецЕсли;
	
	УстановкаДоступностиЭлементовФормы();
	УправлениеКнопкамиПодвал();
	
	Если ВыводитьДокументыНаПечать Тогда
		
		ИменаМакетов = "АктСверкиВзаимныхРасчетов";
		Для Индекс = 2 По КоличествоЭкземпляров Цикл
			ИменаМакетов = ИменаМакетов + ",АктСверкиВзаимныхРасчетов";
		КонецЦикла;
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Документ.СверкаВзаиморасчетов",
			ИменаМакетов,
			МассивДокументовДляПечати,
			Неопределено,
			Неопределено);
		
	КонецЕсли;
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Элементы.Список.Обновить();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СоздатьДокументыСервер()

	ТекущаяДата  = ТекущаяДатаСеанса();
	ТекущееВремя = Час(ТекущаяДата) * 3600 + Минута(ТекущаяДата) * 60 + Секунда(ТекущаяДата);

	ТаблицаОбработанныхДокументов.Очистить();
	
	СуществующиеПомечатьНаУдаление = (ОбработкаСуществующихДокументов = 1);
	СуществующиеПерезаполнять	   = (ОбработкаСуществующихДокументов = 2);

	Для Каждого СтрокаТаблицы Из ТаблицаРасчетов Цикл

		Если НЕ СтрокаТаблицы.СоздаватьДокумент Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ СтрокаТаблицы.СуществуютДокументы
			ИЛИ НЕ СуществующиеПерезаполнять Тогда
			
			ДокументОбъект = Документы.СверкаВзаиморасчетов.СоздатьДокумент();
			
			ДокументОбъект.Дата = ДатаДокументов + ТекущееВремя;
			ЗаполнитьПровестиДокументОбъект(ДокументОбъект, СтрокаТаблицы, Истина);
			
			Если ДокументОбъект.Проведен Тогда
				ДобавитьВПротоколВыполнения(ДокументОбъект.Ссылка, 0); // Создание
			КонецЕсли;

		КонецЕсли;
		
		Если СтрокаТаблицы.СуществуютДокументы
			И (СуществующиеПомечатьНаУдаление ИЛИ СуществующиеПерезаполнять) Тогда

			ОтборСуществующихДокументов = Новый Структура;
			ОтборСуществующихДокументов.Вставить("Организация", СтрокаТаблицы.Организация);
			ОтборСуществующихДокументов.Вставить("Контрагент",  СтрокаТаблицы.Контрагент);
			
			СуществующиеДокументы = ТаблицаСуществующихДокументов.НайтиСтроки(ОтборСуществующихДокументов);
			
			Для Каждого СтрокаСуществующегоДокумента Из СуществующиеДокументы Цикл
				
				ДокументОбъект = СтрокаСуществующегоДокумента.ДокументСсылка.ПолучитьОбъект();
				
				Если СуществующиеПомечатьНаУдаление Тогда
					
					Попытка
						ДокументОбъект.УстановитьПометкуУдаления(Истина);
						ДобавитьВПротоколВыполнения(ДокументОбъект.Ссылка, 1); // Пометка удаления установлена
					Исключение
						ТекстОшибки    = НСтр("ru='Не удалось пометить на удаление %Документ%. %ОписаниеОшибки%'");
						ТекстОшибки    = СтрЗаменить(ТекстОшибки, "%Документ%",       ДокументОбъект);
						ТекстОшибки    = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
						
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ДокументОбъект.Ссылка);
					КонецПопытки;
					
				ИначеЕсли СуществующиеПерезаполнять Тогда
					
					ЗаполнитьПровестиДокументОбъект(ДокументОбъект, СтрокаТаблицы, Ложь);
					
					Если ДокументОбъект.Проведен Тогда
						ДобавитьВПротоколВыполнения(ДокументОбъект.Ссылка, 2); // Перезаполнение
					КонецЕсли;
					
				КонецЕсли;

			КонецЦикла;
			
		КонецЕсли;

	КонецЦикла;
	
	ОбработкаВыполнена = Истина;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПровестиДокументОбъект(ДокументОбъект, СтрокаТаблицыРасчетов, УстанавливатьНовыйНомер)
	
	ДанныеДокумента = Новый Структура;
	ДанныеДокумента.Вставить("Организация",			   СтрокаТаблицыРасчетов.Организация);
	ДанныеДокумента.Вставить("Контрагент",			   СтрокаТаблицыРасчетов.Контрагент);
	ДанныеДокумента.Вставить("Партнер",		 		   Партнер);
	ДанныеДокумента.Вставить("НачалоПериода",		   ПериодСверки.ДатаНачала);
	ДанныеДокумента.Вставить("КонецПериода",		   ПериодСверки.ДатаОкончания);
	ДанныеДокумента.Вставить("Статус",		 		   Перечисления.СтатусыСверокВзаиморасчетов.Создана);
	ДанныеДокумента.Вставить("РасшифровкаПоЗаказам",   РасшифровкаПоЗаказам);
	ДанныеДокумента.Вставить("РасшифровкаПоПартнерам", РасшифровкаПоПартнерам);
	ДанныеДокумента.Вставить("РасшифровкаПоДоговорам", РасшифровкаПоДоговорам);
	ДанныеДокумента.Вставить("ВариантДетализацииВзаиморасчетов", ВариантДетализацииВзаиморасчетов);

	ДокументОбъект.Заполнить(ДанныеДокумента);
	
	Если УстанавливатьНовыйНомер Тогда
		ДокументОбъект.УстановитьНовыйНомер();
	КонецЕсли;
	
	Если ДокументОбъект.ПроверитьЗаполнение() Тогда
		
		Попытка
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ТекстОшибки = НСтр("ru='Не удалось записать %Документ%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%",       ДокументОбъект);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ДокументОбъект.Ссылка);
		КонецПопытки;
		
	Иначе
		
		ТекстОшибки = НСтр("ru='Не удалось записать %Документ%.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ДокументОбъект);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ДокументОбъект.Ссылка);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОДействии(ДокументСсылка, Текст)
	
	НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ДокументСсылка);

	ПоказатьОповещениеПользователя(
		Текст,
		НавигационнаяСсылка,
		Строка(ДокументСсылка),
		БиблиотекаКартинок.Информация32);
	
	Если ДоступноСохранениеДанныхПользователя Тогда
		ИсторияРаботыПользователя.Добавить(НавигационнаяСсылка);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВПротоколВыполнения(ДокументСсылка, Действие)
	
	СтрокаПротокола = ТаблицаОбработанныхДокументов.Добавить();
	
	СтрокаПротокола.ДокументСсылка = ДокументСсылка;
	СтрокаПротокола.Действие	   = Действие;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура УстановкаДоступностиЭлементовФормы()

	Элементы.СтраницыПомощника.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	ВыбранПроизвольныйПериод = (ПериодСверки.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод);
	Элементы.ПериодСверкиДатаНачала.Доступность    = ВыбранПроизвольныйПериод;
	Элементы.ПериодСверкиДатаОкончания.Доступность = ВыбранПроизвольныйПериод;
	
	Элементы.ДетализацияВзаиморасчетов.Доступность = ВариантДетализацииВзаиморасчетов = 1;
	
	Элементы.КоличествоЭкземпляров.Доступность = ВыводитьДокументыНаПечать;
	
	Если НЕ ВыводитьДокументыНаПечать Тогда
		КоличествоЭкземпляров = 0;
	ИначеЕсли КоличествоЭкземпляров = 0 Тогда
		КоличествоЭкземпляров = 1;
	КонецЕсли;
	
	Если ОбработкаВыполнена Тогда
		Элементы.СтраницаФинальная.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ИнициализироватьКомпоновщикНастроек()
	
	СхемаКомпоновкиДанных = Документы.СверкаВзаиморасчетов.ПолучитьМакет("ПомощникСозданияОтбор");
	
	ПартнерыИКонтрагенты.ЗаголовокПоляСКДВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	                      СхемаКомпоновкиДанных.НаборыДанных.Запрос, "Партнер", НСтр("ru = 'Контрагент'"));
	
	АдресВХранилище = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, ЭтаФорма.УникальныйИдентификатор);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресВХранилище);
	
	КомпоновщикОтбор.Инициализировать(ИсточникНастроек);
	
	КомпоновщикОтбор.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	КомпоновщикОтбор.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПереходПоСтраницам(Команда)
	
	Если Команда.Имя = "Далее"
		И Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаНастройкаФильтров Тогда
		
		Если ПараметрыЗаполнены() Тогда
			ЗаполнитьТаблицуРасчетовСервер();
			ПересчитатьКоличествоСтрокТаблицыРасчетов();
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаТаблицаРасчетов;
		КонецЕсли;
		
	ИначеЕсли Команда.Имя = "Далее"
		И Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаТаблицаРасчетов Тогда
		
		Если ПараметрыЗаполнены() Тогда
			
			Если КоличествоСуществующихИОтмеченных <> 0 Тогда
				
				Элементы.ГруппаОбработкаСуществующихДокументов.Видимость = Истина;

				ТекстКоличествоСуществующих = НСтр("ru = '%Выбрано% %КоличествоСтрокой%, для %Которой% сверки уже существуют.
													     |Выберите действие с существующими сверками:'");

				КоличествоСтрокой = ЧислоПрописью(КоличествоСуществующихИОтмеченных,
												  "Л = ru_RU",
												  НСтр("ru = 'строка, строки, строк, ж,,,,,0'"));

				ТекстКоличествоСуществующих = СтрЗаменить(ТекстКоличествоСуществующих, "%Выбрано%", ?(КоличествоСуществующихИОтмеченных = 1,
																										 НСтр("ru = 'Выбрана'"),
																										 НСтр("ru = 'Выбрано'")));
				ТекстКоличествоСуществующих = СтрЗаменить(ТекстКоличествоСуществующих, "%КоличествоСтрокой%", НРег(КоличествоСтрокой));
				ТекстКоличествоСуществующих = СтрЗаменить(ТекстКоличествоСуществующих, "%Которой%", ?(КоличествоСуществующихИОтмеченных = 1,
																										 НСтр("ru = 'которой'"),
																										 НСтр("ru = 'которых'")));
				
				Элементы.ДекорацияСуществующихДокументов.Заголовок = ТекстКоличествоСуществующих;
				
			Иначе
				
				Элементы.ГруппаОбработкаСуществующихДокументов.Видимость = Ложь;
				
			КонецЕсли;
			
			ДетализацияВзаиморасчетов = ПредставлениеДетализацииВзаиморасчетов();
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаФинальная;
			ЗадаватьВопросОЗакрытии = Истина;
			
		КонецЕсли;
		
	ИначеЕсли Команда.Имя = "Далее"
		И Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаФинальная Тогда
		
		Если ОбработкаВыполнена Тогда						// "Готово"
			Закрыть();
		Иначе
			Если ПараметрыЗаполнены() Тогда	// "Создать"
				СоздатьДокументы();
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли Команда.Имя = "Назад"
		И Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаТаблицаРасчетов Тогда
		
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаНастройкаФильтров;
		
	ИначеЕсли Команда.Имя = "Назад"
		И Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаФинальная Тогда
		
		ПересчитатьКоличествоСтрокТаблицыРасчетов();
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаТаблицаРасчетов;
			
	ИначеЕсли Команда.Имя = "Отмена" Тогда
		
		Закрыть();
		
	КонецЕсли;
	
	УправлениеКнопкамиПодвал();
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыЗаполнены()
	
	Отказ = Ложь;
	ОчиститьСообщения();
	
	Если Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаНастройкаФильтров Тогда

		Если ПериодСверки.ДатаОкончания = '00010101' Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указано окончание периода сверки'"),,"ПериодСверки.ДатаОкончания");
			Отказ = Истина;
		КонецЕсли;
		
	ИначеЕсли Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаТаблицаРасчетов Тогда
		
		ПересчитатьКоличествоСтрокТаблицыРасчетов();
		
		Если КоличествоОтмеченных = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбрана ни одна строка'"),,"ТаблицаРасчетов");
			Отказ = Истина;
		КонецЕсли;
		
	ИначеЕсли Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаФинальная Тогда
		
		Если ДатаДокументов = '00010101' Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Указана пустая дата документов'"),,"ДатаДокументов");
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;

	Возврат НЕ Отказ;
	
КонецФункции

&НаСервере
Функция ПредставлениеДетализацииВзаиморасчетов()
	
	Возврат Документы.СверкаВзаиморасчетов.ПредставлениеДетализацииВзаиморасчетов(
		Партнер,
		Неопределено, // Договор
		РасшифровкаПоПартнерам,
		РасшифровкаПоДоговорам,
		РасшифровкаПоЗаказам);
	
КонецФункции

&НаКлиенте
Процедура УправлениеКнопкамиПодвал()
	
	Если Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаНастройкаФильтров Тогда
		
		Элементы.Далее.Заголовок = НСтр("ru='Далее >>'");
		
		Элементы.Назад.Доступность = Ложь;

	ИначеЕсли Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаТаблицаРасчетов Тогда
		
		Элементы.Далее.Заголовок = НСтр("ru='Далее >>'");
		
		Элементы.Назад.Доступность = Истина;

	ИначеЕсли Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаФинальная Тогда
		
		Если ОбработкаВыполнена Тогда
			Элементы.Далее.Заголовок = НСтр("ru='Готово'");
		
			Элементы.Назад.Доступность  = Ложь;
			Элементы.Отмена.Доступность = Ложь;
		Иначе
			Элементы.Далее.Заголовок = НСтр("ru='Создать'");
		
			Элементы.Назад.Доступность = Истина;
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
