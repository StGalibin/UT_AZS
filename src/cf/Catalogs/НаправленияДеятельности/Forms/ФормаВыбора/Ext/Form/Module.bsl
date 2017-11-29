﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РежимВыбора = "Активные";
	
	НастроитьОтборыНаФорме();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимВыбораПриИзменении(Элемент)
	РежимВыбораПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура РежимВыбораПриИзмененииНаСервере()
	
	НовыйСтатус = Перечисления.СтатусыНаправленияДеятельности.Используется;
	Если РежимВыбора = "Все" Тогда
		НовыйСтатус = Перечисления.СтатусыНаправленияДеятельности.ПустаяСсылка();
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Статус",
			НовыйСтатус,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			ЗначениеЗаполнено(НовыйСтатус));
	
КонецПроцедуры

#КонецОбласти

#Область Служебные

Процедура НастроитьОтборыНаФорме()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Статус",
		Перечисления.СтатусыНаправленияДеятельности.Используется,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		Истина);
	
	Если Параметры.Свойство("Ссылка") Тогда
		
		Если ТипЗнч(Параметры.Ссылка) = Тип("СправочникСсылка.ДоговорыКонтрагентов") 
			И Параметры.Свойство("ТипДоговора") Тогда
			
			Если Параметры.ТипДоговора = Перечисления.ТипыДоговоров.СДавальцем Тогда
				
				ОтборГруппаИЛИ = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
				ОтборГруппаИЛИ.Использование = Истина;
				ОтборГруппаИЛИ.Представление = НСтр("ru = 'Доходы или затраты с обособлением'");
				ОтборГруппаИЛИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
				ОтборГруппаИЛИ.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;

				ОтборГруппаДоходыБезЗатрат = ОтборГруппаИЛИ.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
				ОтборГруппаДоходыБезЗатрат.Использование = Истина;
				ОтборГруппаДоходыБезЗатрат.Представление = НСтр("ru = 'Доходы без затрат'");
				ОтборГруппаДоходыБезЗатрат.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
				ОтборГруппаДоходыБезЗатрат.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
				
				ОтборПоЗатратам = ОтборГруппаДоходыБезЗатрат.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				ОтборПоЗатратам.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("УчетЗатрат");
				ОтборПоЗатратам.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
				ОтборПоЗатратам.Использование  = Истина;
				ОтборПоЗатратам.ПравоеЗначение = Ложь;
				
				ОтборПоДоходу = ОтборГруппаДоходыБезЗатрат.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				ОтборПоДоходу.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("УчетДоходов");
				ОтборПоДоходу.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
				ОтборПоДоходу.Использование    = Истина;
				ОтборПоДоходу.ПравоеЗначение   = Истина;
				
				ОтборГруппаИЗатраты = ОтборГруппаИЛИ.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
				ОтборГруппаИЗатраты.Использование = Истина;
				ОтборГруппаИЗатраты.Представление = НСтр("ru = 'затраты с обособлением'");
				ОтборГруппаИЗатраты.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
				ОтборГруппаИЗатраты.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
				
				ОтборПоЗатратам = ОтборГруппаИЗатраты.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				ОтборПоЗатратам.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("УчетЗатрат");
				ОтборПоЗатратам.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
				ОтборПоЗатратам.Использование  = Истина;
				ОтборПоЗатратам.ПравоеЗначение = Истина;
				
				ОтборПоДоходу = ОтборГруппаИЗатраты.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				ОтборПоДоходу.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("УчетДоходов");
				ОтборПоДоходу.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
				ОтборПоДоходу.Использование    = Истина;
				ОтборПоДоходу.ПравоеЗначение   = Истина;
				
				ОтборПоЗатратам = ОтборГруппаИЗатраты.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				ОтборПоЗатратам.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВариантОбособления");
				ОтборПоЗатратам.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
				ОтборПоЗатратам.Использование  = Истина;
				ОтборПоЗатратам.ПравоеЗначение = Перечисления.ВариантыОбособленияПоНаправлениюДеятельности.ПоЗаказамНаправления;
				
			ИначеЕсли Параметры.ТипДоговора = Перечисления.ТипыДоговоров.СПокупателем
				ИЛИ Параметры.ТипДоговора = Перечисления.ТипыДоговоров.СКомиссионером Тогда
				
				Параметры.Отбор.Вставить("УчетДоходов", Истина);
				
			Иначе
				
				Параметры.Отбор.Вставить("УчетЗатрат", Истина);
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями")
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ДвижениеПрочихАктивовПассивов")
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациями")
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациямиОСписании")
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями")
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ПересортицаТоваров")
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ПрочиеДоходыРасходы")
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("СправочникСсылка.ДоговорыМеждуОрганизациями") Тогда
			
			ОтборГруппаИЛИ = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ОтборГруппаИЛИ.Использование = Истина;
			ОтборГруппаИЛИ.Представление = НСтр("ru = 'список комбинаций проект/статус'");
			ОтборГруппаИЛИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
			ОтборГруппаИЛИ.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;

			ОтборПоДоходу = ОтборГруппаИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборПоДоходу.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("УчетДоходов");
			ОтборПоДоходу.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
			ОтборПоДоходу.Использование    = Истина;
			ОтборПоДоходу.ПравоеЗначение   = Истина;

			ОтборПоЗатратам = ОтборГруппаИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборПоЗатратам.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("УчетЗатрат");
			ОтборПоЗатратам.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			ОтборПоЗатратам.Использование  = Истина;
			ОтборПоЗатратам.ПравоеЗначение = Истина;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
