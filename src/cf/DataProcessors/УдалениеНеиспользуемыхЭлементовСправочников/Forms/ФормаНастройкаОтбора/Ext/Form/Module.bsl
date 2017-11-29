﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ПредставлениеСправочника = Параметры.ПредставлениеСправочника;	
	ЗаполнитьКомпоновкуДанныхДляОтборов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	ЕстьОтборКУдалению = (КомпоновщикНастроекДляОтборов.Настройки.Отбор.Элементы.Количество() > 0);
	ЕстьОтборКИсключению = (КомпоновщикНастроекДляОтборовИсключения.Настройки.Отбор.Элементы.Количество() > 0);
	ПараметрыЗакрытияФормы = Новый Структура();
	ПараметрыЗакрытияФормы.Вставить("ОтборКомпоновкиДанных", КомпоновщикНастроекДляОтборов.Настройки.Отбор.Элементы);
	ПараметрыЗакрытияФормы.Вставить("ОтборКомпоновкиДанныхИсключения", 
									КомпоновщикНастроекДляОтборовИсключения.Настройки.Отбор.Элементы);
	ПараметрыЗакрытияФормы.Вставить("ЕстьОтборКУдалению", ЕстьОтборКУдалению);
	ПараметрыЗакрытияФормы.Вставить("ЕстьОтборКИсключению", ЕстьОтборКИсключению);
	ЭтаФорма.Закрыть(ПараметрыЗакрытияФормы);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьКомпоновкуДанныхДляОтборов()
	
	СКД = Новый СхемаКомпоновкиДанных;
	
	ИсточникиДанных = СКД.ИсточникиДанных.Добавить();
	ИсточникиДанных.Имя = "ИсточникДанных";
	ИсточникиДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.ИсточникДанных = "ЗапросПоСправочнику";
	НаборДанных.Запрос = "ВЫБРАТЬ РАЗРЕШЕННЫЕ * ИЗ Справочник."+Параметры.ИмяСправочника;
	НаборДанных.ИсточникДанных = "ИсточникДанных";
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	АдресСхемыКомпоновкиДанныхИсключения = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	
	КомпоновщикНастроекДляОтборов.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	КомпоновщикНастроекДляОтборов.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
	
	КомпоновщикНастроекДляОтборовИсключения.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанныхИсключения));
	КомпоновщикНастроекДляОтборовИсключения.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);

	Если Параметры.ОтборКомпоновкиДанных.Элементы.Количество() > 0 Тогда
		Для Каждого ЭлементОтбора ИЗ Параметры.ОтборКомпоновкиДанных.Элементы Цикл
			ТипЭлементаОтбора = ТипЗнч(ЭлементОтбора);
			НовыйЭлементОтбора = КомпоновщикНастроекДляОтборов.Настройки.Отбор.Элементы.Добавить(ТипЭлементаОтбора);
			ЗаполнитьЗначенияСвойств(НовыйЭлементОтбора, ЭлементОтбора);
		КонецЦикла;
	КонецЕсли;
	Если Параметры.ОтборКомпоновкиДанныхИсключения.Элементы.Количество() > 0 Тогда
		Для Каждого ЭлементОтбора ИЗ Параметры.ОтборКомпоновкиДанныхИсключения.Элементы Цикл
			ТипЭлементаОтбора = ТипЗнч(ЭлементОтбора);
			НовыйЭлементОтбора = КомпоновщикНастроекДляОтборовИсключения.Настройки.Отбор.Элементы.Добавить(ТипЭлементаОтбора);
			ЗаполнитьЗначенияСвойств(НовыйЭлементОтбора, ЭлементОтбора);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
