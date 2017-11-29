﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСВызовСервера.ПриПолученииФормыСправочника(
		"КлассификаторОрганизацийЕГАИС",
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Рассчитывает сопоставлены ли данные ЕГАИС с данными информационной базы.
//
// Параметры:
//  ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектЕГАИС - Склад или партнер.
//  ОрганизацияКонтрагент - ОпределяемыйТип.ОрганизацияКонтрагентЕГАИС - Организация или контрагент.
// 
// Возвращаемое значение:
//  Булево - Признак выполненного сопоставления.
//
Функция РассчитатьСопоставлено(ТорговыйОбъект, ОрганизацияКонтрагент, СоответствуетОрганизации) Экспорт
	
	Сопоставлено = Ложь;
	
	Если СоответствуетОрганизации Тогда
		Если ЗначениеЗаполнено(ТорговыйОбъект) И ЗначениеЗаполнено(ОрганизацияКонтрагент) Тогда
			Сопоставлено = Истина;
		КонецЕсли;
	Иначе
		СтороннийТорговыйОбъект = Неопределено;
		ИнтеграцияЕГАИСПереопределяемый.ЗначенияПоУмолчаниюНеСопоставленныхОбъектов("", "", "", СтороннийТорговыйОбъект);
		
		Если ЗначениеЗаполнено(ОрганизацияКонтрагент) И (ЗначениеЗаполнено(ТорговыйОбъект) ИЛИ СтороннийТорговыйОбъект = Неопределено) Тогда
			Сопоставлено = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Сопоставлено;
	
КонецФункции

// Возвращает ссылку на элемент классификатора организаций ЕГАИС по переданным параметрам.
//
// Параметры:
//  Организация - ОпределяемыйТип.ОрганизацияКонтрагентЕГАИС - ссылка на собственную организацию или контрагента,
//  ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектЕГАИС - ссылка на собственный торговый объект или партнера,
//  СоответствуетОрганизации - Булево - если Истина, то будут отобраны только элементы, являющиеся собственными юр. лицами,
//  ТолькоСопоставленные - Булево - если Истина, то будут выбраны только корректно сопоставленные элементы.
//
// Возвращаемое значение:
//  СправочникСсылка.КлассификаторОрганизацийЕГАИС - найденная организация,
//  Неопределено - организация с переданными параметрами не найдена.
//
Функция ОрганизацияЕГАИСПоОрганизацииИТорговомуОбъекту(Организация, ТорговыйОбъект, СоответствуетОрганизации = Истина, ТолькоСопоставленные = Истина) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагент"              , Организация);
	Запрос.УстановитьПараметр("ТорговыйОбъект"          , ТорговыйОбъект);
	Запрос.УстановитьПараметр("СоответствуетОрганизации", СоответствуетОрганизации);
	Запрос.УстановитьПараметр("ТолькоСопоставленные"    , ТолькоСопоставленные);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	НЕ КлассификаторОрганизацийЕГАИС.ПометкаУдаления
	|	И КлассификаторОрганизацийЕГАИС.Контрагент = &Контрагент
	|	И КлассификаторОрганизацийЕГАИС.ТорговыйОбъект = &ТорговыйОбъект
	|	И КлассификаторОрганизацийЕГАИС.СоответствуетОрганизации = &СоответствуетОрганизации
	|	И ВЫБОР
	|			КОГДА &ТолькоСопоставленные
	|				ТОГДА КлассификаторОрганизацийЕГАИС.Сопоставлено
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить()[0].Ссылка;
	
КонецФункции

#КонецОбласти

#КонецЕсли