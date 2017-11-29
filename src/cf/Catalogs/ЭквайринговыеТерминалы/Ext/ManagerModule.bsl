﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция определяет реквизиты выбранного эквайрингового терминала.
//
// Параметры:
//    ЭквайринговыйТерминал - СправочникСсылка.ЭквайринговыеТерминалы - Ссылка на эквайринговый терминал
//
// Возвращаемое значение:
//    Структура - Реквизиты эквайрингового терминала
//
Функция ПолучитьРеквизитыЭквайринговогоТерминала(ЭквайринговыйТерминал) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ЭквайринговыеТерминалы.БанковскийСчет.Владелец КАК Организация,
	|	ЭквайринговыеТерминалы.БанковскийСчет.ВалютаДенежныхСредств КАК Валюта,
	|	ЭквайринговыеТерминалы.Эквайер КАК Эквайер,
	|	ЭквайринговыеТерминалы.РазрешитьПлатежиБезУказанияЗаявок
	|ИЗ
	|	Справочник.ЭквайринговыеТерминалы КАК ЭквайринговыеТерминалы
	|ГДЕ
	|	ЭквайринговыеТерминалы.Ссылка = &ЭквайринговыйТерминал
	|");
	
	Запрос.УстановитьПараметр("ЭквайринговыйТерминал", ЭквайринговыйТерминал);
	
	СтруктураРеквизитов = Новый Структура("Организация, Валюта, Эквайер, РазрешитьПлатежиБезУказанияЗаявок");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Выборка);
	КонецЕсли;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

// Функция определяет эквайринговый терминал по выбранной организации.
//
// Возвращает эквайринговый терминал, если найден один эквайринговый терминал.
// Возвращает пустую ссылку, если эквайринговый терминал не найден или эквайринговых терминалов больше одного.
//
// Параметры:
//    Организация - СправочникСсылка.Организации - Выбранная организация
//
// Возвращаемое значение:
//    СправочникСсылка.ЭквайринговыеТерминалы - Найденный эквайринговый терминал
//
Функция ПолучитьЭквайринговыйТерминалПоУмолчанию(Организация = Неопределено) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	ЭквайринговыеТерминалы.Ссылка КАК ЭквайринговыйТерминал
	|ИЗ
	|	Справочник.ЭквайринговыеТерминалы КАК ЭквайринговыеТерминалы
	|ГДЕ
	|	НЕ ЭквайринговыеТерминалы.ПометкаУдаления
	|	И (ЭквайринговыеТерминалы.БанковскийСчет.Владелец = &Организация
	|		ИЛИ &Организация = Неопределено)
	|");
	
	Запрос.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Организация), Организация, Неопределено));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
		ЭквайринговыйТерминал = Выборка.ЭквайринговыйТерминал;
	Иначе
		ЭквайринговыйТерминал = Справочники.ЭквайринговыеТерминалы.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ЭквайринговыйТерминал;
	
КонецФункции

// Функция получения списка эквайеров, с которыми заключен договор для указанного банковского счета
//
// Параметры:
//	БанковскийСчет - СправочникСсылка.БанковскиеСчетаОрганизаций - Банковский счет
//
// Возвращаемое значение:
//	Массив - Массив эквайеров
//
Функция ЭквайерыПоБанковскомуСчету(БанковскийСчет = Неопределено) Экспорт
	
	МассивЭквайеров = Новый Массив;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЭквайринговыеТерминалы.Эквайер КАК Эквайер
	|ИЗ
	|	Справочник.ЭквайринговыеТерминалы КАК ЭквайринговыеТерминалы
	|ГДЕ
	|	(ЭквайринговыеТерминалы.БанковскийСчет = &БанковскийСчет
	|	ИЛИ &БанковскийСчет = НЕОПРЕДЕЛЕНО)
	|	И НЕ ЭквайринговыеТерминалы.ПометкаУдаления
	|	И НЕ ЭквайринговыеТерминалы.ЭтоГруппа
	|");
	
	Запрос.УстановитьПараметр("БанковскийСчет", БанковскийСчет);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		МассивЭквайеров = Результат.Выгрузить().ВыгрузитьКолонку("Эквайер");
	КонецЕсли;
	
	Возврат МассивЭквайеров;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Реквизиты = ДенежныеСредстваВызовСервера.ЗначенияРеквизитовЭквайринговогоТерминала(Данные.Ссылка);
	
	Если ЗначениеЗаполнено(Реквизиты.ЭтоГруппа) И Не Реквизиты.ЭтоГруппа
		И ЗначениеЗаполнено(Реквизиты.Код) И СокрЛП(Реквизиты.Код) <> "0" Тогда
		СтандартнаяОбработка = Ложь;
		Представление = СокрЛП(Реквизиты.Код) + ", " + СокрЛП(Данные.Наименование);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("БанковскийСчет");
	Результат.Добавить("Эквайер");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли