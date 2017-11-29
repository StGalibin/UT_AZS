﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗагрузитьСписок(Отказ);
	
	ИнициализироватьСписокДокументов();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = РеквизитФормыВЗначение("СписокСозданныеДокументы").Колонки["Ссылка"].ТипЗначения;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьЗаголовок();
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗакрытьБезВопроса Тогда
		
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
			ТекстПредупреждения = НСтр("ru = 'Данные были изменены. Все изменения будут потеряны.'");
			Возврат;
		КонецЕсли;
		
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Принять и закрыть'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Отменить и удалить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		ТекстВопроса = НСтр("ru = 'Выберите действие, которое необходимо произвести с созданными документами'");
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросОЗакрытии", ЭтотОбъект), ТекстВопроса, Кнопки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПриобретениеТоваровУслуг"
		Или ИмяСобытия = "Запись_ПриемкаТоваровНаХранение" Тогда
		
		ИнициализироватьСписокДокументов();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокСозданныеДокументы

&НаКлиенте
Процедура СписокСозданныеДокументыПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокСозданныеДокументы);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокСозданныеДокументы, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокСозданныеДокументы);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура НазадЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьСозданныеДокументы();
	
	Оповестить("Запись_ПриобретениеТоваровУслуг"); // Нужно обновить список к оформлению
	
	ЗакрытьБезВопроса = Истина;
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСозданныеДокументы()
	
	МассивСсылокНаУдаление = СписокСозданныеДокументы.Выгрузить(, "Ссылка").ВыгрузитьКолонку("Ссылка");
	СписокОшибок           = ОбщегоНазначенияУТ.УдалитьДокументы(МассивСсылокНаУдаление);
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(СписокОшибок);
	СписокСозданныеДокументы.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Если СписокСозданныеДокументы.Количество() > 0 Тогда
		
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Удалить сформированные документы'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		ТекстВопроса = НСтр("ru = 'При переходе назад сформированные документы будут удалены.'");
		
		ПоказатьВопрос(Новый ОписаниеОповещения("НазадЗавершение", ЭтотОбъект), ТекстВопроса, Кнопки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Принять(Команда)
	ЗакрытьБезВопроса = Истина;
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура СписокСозданныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ЗагрузитьСписок(Отказ)
	
	//ОбъектыМетаданных  = Новый Массив;
	СозданныеДокументы = ПрочитатьДанныеИзБезопасногоХранилища();
	
	Если ЗначениеЗаполнено(СозданныеДокументы) Тогда
		УдалитьДанныеИзБезопасногоХранилища();
	Иначе
		Отказ = Истина;
		
		ВызватьИсключение НСтр("ru='Произошла исключительная ситуация при создании документов.'");
	КонецЕсли;
	
	Для Каждого ТекСтрока Из СозданныеДокументы Цикл
		СписокДокументов.Добавить(ТекСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрочитатьДанныеИзБезопасногоХранилища()
	
	УстановитьПривилегированныйРежим(Истина);
	ЗащищенныеДанные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Пользователи.АвторизованныйПользователь(),
																			"ФормаСозданныеДокументыЗакупки");
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ЗащищенныеДанные
	
КонецФункции

&НаСервереБезКонтекста
Процедура УдалитьДанныеИзБезопасногоХранилища()
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(Пользователи.АвторизованныйПользователь(),
														"ФормаСозданныеДокументыЗакупки");
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьСписокДокументов()
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Документы", СписокДокументов.ВыгрузитьЗначения());
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеДокументов.Ссылка,
	|	ДанныеДокументов.МестоХранения КАК Склад,
	|	ДанныеДокументов.Организация,
	|	ДанныеДокументов.ХозяйственнаяОперация,
	|	ВЫБОР
	|		КОГДА ДанныеДокументов.Проведен
	|			ТОГДА 0
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ДанныеДокументов.ПометкаУдаления
	|					ТОГДА 1
	|				ИНАЧЕ 2
	|			КОНЕЦ
	|	КОНЕЦ КАК Картинка,
	|	ДанныеДокументов.Партнер,
	|	ДанныеДокументов.Контрагент,
	|	ДанныеДокументов.НаправлениеДеятельности
	|
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК ДанныеДокументов
	|ГДЕ
	|	ДанныеДокументов.Ссылка В(&Документы)
	|	И НЕ ДанныеДокументов.ДополнительнаяЗапись
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДанныеДокументов.Ссылка,
	|	ВТДанныеДокументов.Склад,
	|	ВТДанныеДокументов.Организация,
	|	ВТДанныеДокументов.ХозяйственнаяОперация,
	|	ВТДанныеДокументов.Картинка,
	|	ВТДанныеДокументов.Партнер,
	|	ВТДанныеДокументов.Контрагент,
	|	ВТДанныеДокументов.НаправлениеДеятельности
	|ИЗ
	|	ВТДанныеДокументов КАК ВТДанныеДокументов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВТДанныеДокументов.Ссылка),
	|	МАКСИМУМ(ВТДанныеДокументов.Склад),
	|	МАКСИМУМ(ВТДанныеДокументов.Организация),
	|	МАКСИМУМ(ВТДанныеДокументов.ХозяйственнаяОперация),
	|	МАКСИМУМ(ВТДанныеДокументов.Картинка),
	|	МАКСИМУМ(ВТДанныеДокументов.Партнер),
	|	МАКСИМУМ(ВТДанныеДокументов.Контрагент),
	|	МАКСИМУМ(ВТДанныеДокументов.НаправлениеДеятельности)
	|ИЗ
	|	ВТДанныеДокументов КАК ВТДанныеДокументов";
	
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаКолонки = Результат[2].Выбрать();
	ВыборкаКолонки.Следующий();
	Для Каждого ЭлементПоле Из Элементы.СписокСозданныеДокументы.ПодчиненныеЭлементы Цикл
		ЧастиПути = СтрРазделить(ЭлементПоле.ПутьКДанным,".");
		Если ЗначениеЗаполнено(ЧастиПути[0])
			И ЭтаФорма[ЧастиПути[0]] = СписокСозданныеДокументы Тогда
			ЭлементПоле.Видимость = ЗначениеЗаполнено(ВыборкаКолонки[ЧастиПути[1]]);
		КонецЕсли;
	КонецЦикла;
	СписокСозданныеДокументы.Загрузить(Результат[1].Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовок() 
	
	КоличествоДокументов = СписокСозданныеДокументы.Количество();
	
	СклонениеСоздано = НСтр("ru = 'Создан, Создано, Создано'");
	Создано = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоДокументов, СклонениеСоздано);
	Создано = СтрЗаменить(Создано, КоличествоДокументов + " ", "");
	
	СклонениеДокументов = НСтр("ru = 'документ, документа, документов'");
	Документов = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоДокументов, СклонениеДокументов);
	
	Заголовок = Создано + " " + Документов;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОЗакрытии(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		НазадЗавершение(Ответ, Неопределено);
	Иначе
		ЗакрытьБезВопроса = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормы()

	ОтправительСклад = Ложь;
	ОтправительПодразделение = Ложь;
	
	Для каждого ДанныеСтроки Из СписокСозданныеДокументы Цикл
		
		Если ЗначениеЗаполнено(ДанныеСтроки.Склад) И ТипЗнч(ДанныеСтроки.Склад) = Тип("СправочникСсылка.Склады") Тогда
			ОтправительСклад = Истина;
		КонецЕсли;
		Если ЗначениеЗаполнено(ДанныеСтроки.Склад) И ТипЗнч(ДанныеСтроки.Склад) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
			ОтправительПодразделение = Истина;
		КонецЕсли;
		
		Если ОтправительСклад И ОтправительПодразделение Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОтправительСклад И ОтправительПодразделение Тогда
		Элементы.СписокСозданныеДокументыСклад.Заголовок = НСтр("ru = 'Отправитель'");
	ИначеЕсли ОтправительПодразделение Тогда
		Элементы.СписокСозданныеДокументыСклад.Заголовок = НСтр("ru = 'Подразделение'");
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти