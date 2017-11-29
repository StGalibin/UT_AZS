﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор, "Организация", Параметры.Организация, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;
	
	ОформитьИСкрытьНедействительныеНастройки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СоздатьНастройкуЯндексКассы(Команда)
	
	ПараметрыФормы = Новый Структура;
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Организация", Параметры.Организация);
	
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);

	ОткрытьФорму("Справочник.НастройкиЯндексКассы.Форма.ФормаЭлемента", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительныеНастройкиПриИзменении(Элемент)
	
	ПереключитьОтображениеНедействительныхНастроек(ПоказыватьНедействительныеНастройки);
	
КонецПроцедуры

#КонецОбласти



#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПереключитьОтображениеНедействительныхНастроек(ПоказатьНедействительные)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Недействительна", Ложь, , , НЕ ПоказатьНедействительные);
	
КонецПроцедуры

&НаСервере
Процедура ОформитьИСкрытьНедействительныеНастройки()
	
	// Оформление.
	УсловноеОформление.Элементы.Очистить();
	
	// Фон недействительной настройки
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Фон недействительной настройки'");
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Недействительна");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	// Скрытие.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Недействительна", Ложь, , , Истина);
	
КонецПроцедуры

#КонецОбласти
