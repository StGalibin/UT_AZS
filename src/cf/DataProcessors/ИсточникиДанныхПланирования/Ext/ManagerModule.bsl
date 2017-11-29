﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Функция ШаблоныСхемыКомпоновкиДанных() Экспорт
	
	Шаблоны = Новый Массив;
	
	Для каждого Макет из Метаданные.Обработки.ИсточникиДанныхПланирования.Макеты Цикл
		
		Если Макет.ТипМакета <> Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если Макет.Имя = "ЗаказыКлиентов" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов")
			ИЛИ Макет.Имя = "ЗаказыПоставщикам" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам")
			ИЛИ Макет.Имя = "ЗаказыНаВнутреннееПотребление" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаВнутреннееПотребление")
			ИЛИ Макет.Имя = "ЗаказыНаПеремещениеОтгрузка" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаПеремещение")
			ИЛИ Макет.Имя = "ЗаказыНаПеремещениеПоступление" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаПеремещение")
			ИЛИ Макет.Имя = "ЗаказыНаСборкуОтгрузка" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаСборку")
			ИЛИ Макет.Имя = "ЗаказыНаСборкуПоступление" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаСборку")
			ИЛИ Макет.Имя = "ПланыЗакупокПредопределенный" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеЗакупок")
			ИЛИ Макет.Имя = "ПланыПродажПредопределенный" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродаж") 
			ИЛИ Макет.Имя = "ПланыПродажКомплектующиеПредопределенный" 
				И (НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродаж") 
					ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСборкуРазборку"))
			ИЛИ Макет.Имя = "ПланыСборкиКомплектующиеПредопределенный" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеСборкиРазборки")
			ИЛИ Макет.Имя = "ПланыСборкиРазборкиКомплектыПредопределенный" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеСборкиРазборки")
			ИЛИ Макет.Имя = "ПланыПродажПоКатегориямПредопределенный" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродажПоКатегориям")
			ИЛИ Макет.Имя = "СборкаРазборкаПредопределенный" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСборкуРазборку") Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если Макет.Имя = "ЦеныНоменклатуры" Тогда
			ТекстЗапроса = Макет.НаборыДанных.ЦеныНоменклатуры.Запрос;
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
				"&ТекстЗапросаКоэффициентУпаковки",
				Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
				"ЦеныНоменклатурыСрезПоследних.Упаковка",
				"ЦеныНоменклатурыСрезПоследних.Номенклатура"));
			Макет.НаборыДанных.ЦеныНоменклатуры.Запрос = ТекстЗапроса;
		ИначеЕсли Макет.Имя = "ЦеныНоменклатурыПоставщиков" Тогда
			ТекстЗапроса = Макет.НаборыДанных.ЦеныНоменклатуры.Запрос;
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
				"&ТекстЗапросаКоэффициентУпаковки",
				Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
				"ЦеныНоменклатурыПоставщиковСрезПоследних.Упаковка",
				"ЦеныНоменклатурыПоставщиковСрезПоследних.Номенклатура"));
			Макет.НаборыДанных.ЦеныНоменклатуры.Запрос = ТекстЗапроса;
		ИначеЕсли Макет.Имя = "МинимальнаяЦенаПоставщика" Тогда
			ТекстЗапроса = Макет.НаборыДанных.ЦеныНоменклатуры.Запрос;
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
				"&ТекстЗапросаКоэффициентУпаковки",
				Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
				"ЦеныНоменклатурыПоставщиковСрезПоследних.Упаковка",
				"ЦеныНоменклатурыПоставщиковСрезПоследних.Номенклатура"));
			Макет.НаборыДанных.ЦеныНоменклатуры.Запрос = ТекстЗапроса;
		КонецЕсли;

		Шаблоны.Добавить(Новый Структура("Имя, Синоним, ПолноеИмяИсточникаШаблонов", Макет.Имя, Макет.Синоним, "Обработка.ИсточникиДанныхПланирования"));
		
	КонецЦикла;
	
	Возврат Шаблоны;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// В процедуре вызываются обработчики результат полученного из компоновки
Процедура ПослеВыборкиДанных(ТаблицаРезультата, ПараметрыИсточникаДанных, ПользовательскиеНастройки, ДополнительныеПараметры, КомпоновщикНастроекКомпоновкиДанных) Экспорт 
	
	ИмяШаблонаСКД = ПараметрыИсточникаДанных.ИсточникДанныхПланирования.ИмяШаблонаСКД;
	Если ИмяШаблонаСКД = "Обработка.ИсточникиДанныхПланирования.ПланыПродажКомплектующиеПредопределенный" Тогда
		
		РасшифроватьПоКомплектующим(ТаблицаРезультата, КомпоновщикНастроекКомпоновкиДанных, ДополнительныеПараметры);
		
	ИначеЕсли ИмяШаблонаСКД = "Обработка.ИсточникиДанныхПланирования.ПланыПродажПоКатегориямПредопределенный" Тогда
		
		ПересчитатьКоличествоПоНормативамРаспределения(ТаблицаРезультата, КомпоновщикНастроекКомпоновкиДанных, ДополнительныеПараметры);
	
	КонецЕсли; 

КонецПроцедуры

#Область ПроцедурыОбработкиДанныхМакетов

Процедура ПересчитатьКоличествоПоНормативамРаспределения(ТаблицаРезультата, КомпоновщикНастроекКомпоновкиДанных, ДополнительныеПараметры)
	
	Если ТаблицаРезультата.Колонки.Найти("Номенклатура") = Неопределено ИЛИ ТаблицаРезультата.Колонки.Найти("Количество") = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ИмяПоляПоказателя = Новый Массив;
	ИмяПоляПоказателя.Добавить("Количество");
	
	Если ТаблицаРезультата.Колонки.Найти("Период") = Неопределено Тогда
		
		КолонкаПериода = ТаблицаРезультата.Колонки.Добавить("Период", ОбщегоНазначенияУТ.ПолучитьОписаниеТиповДаты(ЧастиДаты.Дата));
		ТаблицаРезультата.ЗаполнитьЗначения(ДополнительныеПараметры.ПараметрыДанных.НачалоПериода, "Период");
		
		Документы.НормативРаспределенияПлановПродажПоКатегориям.ПересчитатьПоказателиПоНормативамРаспределения(ТаблицаРезультата, ИмяПоляПоказателя);
		
		ТаблицаРезультата.Колонки.Удалить(КолонкаПериода);
		
	Иначе
		Документы.НормативРаспределенияПлановПродажПоКатегориям.ПересчитатьПоказателиПоНормативамРаспределения(ТаблицаРезультата, ИмяПоляПоказателя);
	КонецЕсли;
	
КонецПроцедуры

#Область Обработка_макета_ПланыПродажКомплектующиеПредопределенный

Процедура РасшифроватьПоКомплектующим(ТаблицаРезультата, КомпоновщикНастроекКомпоновкиДанных, ДополнительныеПараметры)

	ДобавитьОбязательныеКолонкиКомплектации(ТаблицаРезультата, КомпоновщикНастроекКомпоновкиДанных, ДополнительныеПараметры);
	
	Разузловать = ЗначениеПараметра("Разузловать", КомпоновщикНастроекКомпоновкиДанных, Ложь);
	
	СобираемыеТовары = СобираемыеТовары(ТаблицаРезультата);
	ТаблицаРезультата.Очистить();
	
	ЗначенияРеквизитовПоУмолчанию = Новый Структура;
	ЗначенияРеквизитовПоУмолчанию.Вставить("Цена",  0);
	ЗначенияРеквизитовПоУмолчанию.Вставить("Сумма", 0);
	
	ДобавитьКомплектующиеТоваров(
			ТаблицаРезультата, 
			СобираемыеТовары, 
			Разузловать, 
			ЗначенияРеквизитовПоУмолчанию);

КонецПроцедуры

Функция СобираемыеТовары(ТаблицаТовары)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаТовары.Склад            КАК Склад,
	|	ТаблицаТовары.Период           КАК Период,
	|	ВЫРАЗИТЬ(ТаблицаТовары.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ТаблицаТовары.Характеристика   КАК Характеристика,
	|	ТаблицаТовары.Количество       КАК Количество
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Склад,
	|	Номенклатура,
	|	Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|" + СтрЗаменить(
			РегистрыСведений.СхемыОбеспечения.ВременнаяТаблицаСпособыОбеспечения("ВЫЧИСЛЯТЬ"),
			"ВтТовары",
			"ТаблицаТовары")
	+"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаТовары.Склад            КАК Склад,
	|	ТаблицаТовары.Период           КАК Период,
	|	ТаблицаТовары.Номенклатура     КАК Номенклатура,
	|	ТаблицаТовары.Характеристика   КАК Характеристика,
	|	ТаблицаТовары.Количество       КАК Количество
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтСпособыОбеспечения КАК СпрСпособОбеспечения
	|		ПО ТаблицаТовары.Склад = СпрСпособОбеспечения.Склад
	|			И ТаблицаТовары.Номенклатура = СпрСпособОбеспечения.Номенклатура
	|			И ТаблицаТовары.Характеристика = СпрСпособОбеспечения.Характеристика
	|		
	|ГДЕ
	|	ТаблицаТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
	|	И СпрСпособОбеспечения.СпособОбеспеченияПотребностей.ТипОбеспечения = ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.СборкаРазборка)";

	Запрос.УстановитьПараметр("ТаблицаТовары", ТаблицаТовары);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

Процедура ДобавитьОбязательныеКолонкиКомплектации(ТаблицаРезультата, КомпоновщикНастроекКомпоновкиДанных, ДополнительныеПараметры)

	Если ТаблицаРезультата.Колонки.Найти("Характеристика") = Неопределено Тогда
		
		ТипКолонки = Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры");
		ТаблицаРезультата.Колонки.Добавить("Характеристика", ТипКолонки);

	КонецЕсли;
	
	Если ТаблицаРезультата.Колонки.Найти("Количество") = Неопределено Тогда
		
		ТипКолонки = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,3, ДопустимыйЗнак.Неотрицательный));
		ТаблицаРезультата.Колонки.Добавить("Количество", ТипКолонки);

	КонецЕсли;
	
	Если ТаблицаРезультата.Колонки.Найти("Период") = Неопределено Тогда
		
		ТаблицаРезультата.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
		ТаблицаРезультата.ЗаполнитьЗначения(ТекущаяДатаСеанса(), "Период");

	КонецЕсли;
	
	Если ТаблицаРезультата.Колонки.Найти("Склад") = Неопределено Тогда
		
		ТаблицаРезультата.Колонки.Добавить("Склад", Новый ОписаниеТипов("СправочникСсылка.Склады"));
		
		Если ДополнительныеПараметры.ПараметрыДанных.Свойство("Склад") Тогда
			СкладПоУмолчанию = ДополнительныеПараметры.ПараметрыДанных.Склад;
		Иначе
			СкладПоУмолчанию = Справочники.Склады.ПустаяСсылка();
		КонецЕсли; 
		
		ТаблицаРезультата.ЗаполнитьЗначения(СкладПоУмолчанию, "Склад");

	КонецЕсли;
	
	Если ТаблицаРезультата.Колонки.Найти("ВариантКомплектации") = Неопределено Тогда
		
		ТаблицаРезультата.Колонки.Добавить("ВариантКомплектации", Новый ОписаниеТипов("СправочникСсылка.ВариантыКомплектацииНоменклатуры"));

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Получение_комплектующих_из_НСИ

Процедура ДобавитьКомплектующиеТоваров(ТаблицаРезультата, СобираемыеТовары, Разузловать = Ложь, ЗначенияРеквизитовПоУмолчанию = Неопределено, ОтборПоТипуОбеспечения = Неопределено)

	Если СобираемыеТовары.Колонки.Найти("ВариантКомплектации") = Неопределено Тогда
		СобираемыеТовары.Колонки.Добавить("ВариантКомплектации", Новый ОписаниеТипов("СправочникСсылка.ВариантыКомплектацииНоменклатуры"));
	КонецЕсли;
	Если СобираемыеТовары.Колонки.Найти("Склад") = Неопределено Тогда
		СобираемыеТовары.Колонки.Добавить("Склад", Новый ОписаниеТипов("СправочникСсылка.Склады"));
	КонецЕсли;
	
	Пока СобираемыеТовары.Количество() <> 0 Цикл
		
		ТоварыИКомплектующие = ТоварыИКомплектующие(СобираемыеТовары);
		
		СобираемыеТовары.Очистить();
		
		ТаблицаКомплектующие = ТоварыИКомплектующие.ТаблицаКомплектующие;
		ТаблицаКомплектующие.Индексы.Добавить("ТоварНоменклатура,ТоварХарактеристика,Склад,Период");
		
		ТаблицаТовары = ТоварыИКомплектующие.ТаблицаТовары;
		
		Для каждого СтрокаТовар Из ТаблицаТовары Цикл
			
			// Найдем вариант комплектации
			СтруктураПоиска = Новый Структура("ТоварНоменклатура,ТоварХарактеристика,Склад,Период", 
										СтрокаТовар.Номенклатура, СтрокаТовар.Характеристика, СтрокаТовар.Склад, СтрокаТовар.Период);
										
			СписокКомплектующих = ТаблицаКомплектующие.НайтиСтроки(СтруктураПоиска);
			ВариантыКомплектации = Новый Массив;
			Для каждого СтрокаКомплектующие Из СписокКомплектующих Цикл
				Если ВариантыКомплектации.Найти(СтрокаКомплектующие.ВариантКомплектации) = Неопределено Тогда
					Если СтрокаКомплектующие.Основной Тогда
						ВариантыКомплектации.Очистить();
						ВариантыКомплектации.Добавить(СтрокаКомплектующие.ВариантКомплектации);
						Прервать;
					Иначе
						ВариантыКомплектации.Добавить(СтрокаКомплектующие.ВариантКомплектации);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Если ВариантыКомплектации.Количество() <> 1 Тогда
				// Добавить комплектующие можно если вариант комплектации основной или единственный
				Продолжить;
			КонецЕсли;
			
			ВариантКомплектации = ВариантыКомплектации[0];
			
			Для каждого СтрокаКомплектующие Из СписокКомплектующих Цикл
				
				Если СтрокаКомплектующие.ВариантКомплектации <> ВариантКомплектации Тогда
					Продолжить;
				КонецЕсли;
				
				Если ОтборПоТипуОбеспечения = Неопределено ИЛИ СтрокаКомплектующие.ТипОбеспечения = ОтборПоТипуОбеспечения Тогда
					СтрокаНоваяКомплектующая = ТаблицаРезультата.Добавить();
					Если ЗначенияРеквизитовПоУмолчанию <> Неопределено Тогда
						ЗаполнитьЗначенияСвойств(СтрокаНоваяКомплектующая, ЗначенияРеквизитовПоУмолчанию);
					КонецЕсли;
					ЗаполнитьЗначенияСвойств(СтрокаНоваяКомплектующая, СтрокаКомплектующие);
					СтрокаНоваяКомплектующая.ВариантКомплектации = ВариантКомплектации;
				КонецЕсли;
				
				Если СтрокаКомплектующие.ТипОбеспечения = Перечисления.ТипыОбеспечения.СборкаРазборка Тогда
					СтрокаНоваяИсходнаяКомплектующая = СобираемыеТовары.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаНоваяИсходнаяКомплектующая, СтрокаКомплектующие);
				КонецЕсли; 
				
			КонецЦикла; 
			
		КонецЦикла;
		
		Если НЕ Разузловать Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТоварыИКомплектующие(ТаблицаТовары)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаТовары.Склад                 КАК Склад,
	|	ТаблицаТовары.Период                КАК Период,
	|	ВЫРАЗИТЬ(ТаблицаТовары.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ТаблицаТовары.Характеристика        КАК Характеристика,
	|	ТаблицаТовары.ВариантКомплектации   КАК ВариантКомплектации,
	|	ТаблицаТовары.Количество            КАК Количество
	|ПОМЕСТИТЬ ВтТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	ВариантКомплектации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|"
	+ Справочники.ФорматыМагазинов.ТекстЗапросаВтФорматыСкладов() +
	// 2
	"
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаТовары.Склад                           КАК Склад,
	|	ТаблицаТовары.Номенклатура                    КАК ТоварНоменклатура,
	|	ТаблицаТовары.Характеристика                  КАК ТоварХарактеристика,
	|	ТаблицаТовары.Период                          КАК Период,
	|	ВариантыКомплектацииНоменклатуры.Ссылка       КАК ВариантКомплектации,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.ВариантКомплектации <> ЗНАЧЕНИЕ(Справочник.ВариантыКомплектацииНоменклатуры.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ВариантыКомплектацииНоменклатуры.Основной
	|	КОНЕЦ                                         КАК Основной,
	|	ТаблицаКомплектующие.Номенклатура             КАК Номенклатура,
	|	ТаблицаКомплектующие.Характеристика           КАК Характеристика,
	|	ТаблицаКомплектующие.Номенклатура.ТоварнаяКатегория КАК ТоварнаяКатегория,
	|	ТаблицаКомплектующие.Номенклатура.РейтингПродаж     КАК РейтингПродаж,
	|	ТаблицаКомплектующие.Количество 
	|		* ТаблицаТовары.Количество 
	|		/ ВариантыКомплектацииНоменклатуры.Количество КАК Количество,
	|	ЕСТЬNULL(СпрСпособОбеспечения.ТипОбеспечения, 
	|		ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.ПустаяСсылка)) КАК ТипОбеспечения
	|ИЗ
	|	Справочник.ВариантыКомплектацииНоменклатуры КАК ВариантыКомплектацииНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтТовары КАК ТаблицаТовары
	|		ПО (ТаблицаТовары.Номенклатура = ВариантыКомплектацииНоменклатуры.Владелец)
	|			И (ТаблицаТовары.Характеристика = ВариантыКомплектацииНоменклатуры.Характеристика)
	|			И (ТаблицаТовары.ВариантКомплектации = ЗНАЧЕНИЕ(Справочник.ВариантыКомплектацииНоменклатуры.ПустаяСсылка)
	|				ИЛИ ТаблицаТовары.ВариантКомплектации = ВариантыКомплектацииНоменклатуры.Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВариантыКомплектацииНоменклатуры.Товары КАК ТаблицаКомплектующие
	|		ПО (ТаблицаКомплектующие.Ссылка = ВариантыКомплектацииНоменклатуры.Ссылка)
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СпособыОбеспеченияПотребностей КАК СпрСпособОбеспечения
	|		ПО &ПодстановкаОсновногоСпособаОбеспечения
	|
	|ГДЕ
	|	НЕ ВариантыКомплектацииНоменклатуры.ПометкаУдаления";

	Запрос.Текст = РегистрыСведений.СхемыОбеспечения.ПодставитьСоединениеДляПолученияСпособаОбеспечения(
		Запрос.Текст,
		"ПодстановкаОсновногоСпособаОбеспечения",
		"ТаблицаКомплектующие.Номенклатура,ТаблицаКомплектующие.Характеристика,ТаблицаТовары.Склад");

	ТаблицаТоварыКопия = ТаблицаТовары.Скопировать();
	Запрос.УстановитьПараметр("ТаблицаТовары", ТаблицаТоварыКопия);
	
	Результат = Запрос.Выполнить();

	Возврат Новый Структура("ТаблицаТовары, ТаблицаКомплектующие", 
							ТаблицаТоварыКопия, Результат.Выгрузить());
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область Прочее

Функция ЗначениеПараметра(ИмяПараметра, КомпоновщикНастроекКомпоновкиДанных, ЗначениеПоУМолчанию = Неопределено)

	ЗначениеПараметра = Неопределено;
	ПараметрРазузловать = КомпоновщикНастроекКомпоновкиДанных.Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	Если ПараметрРазузловать <> Неопределено Тогда
		Идентификатор = ПараметрРазузловать.ИдентификаторПользовательскойНастройки;
		ЭлементНастройки = КомпоновщикНастроекКомпоновкиДанных.ПользовательскиеНастройки.Элементы.Найти(Идентификатор);
		Если ЭлементНастройки <> Неопределено Тогда
			ЗначениеПараметра = ЭлементНастройки.Значение;
		КонецЕсли; 
	КонецЕсли; 

	Возврат ЗначениеПараметра;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли