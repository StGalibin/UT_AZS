﻿////////////////////////////////////////////////////////////////////////////////
// Модуль "ПодарочныеСертификатыКлиент", содержит процедуры и функции для 
// обработки действий пользователя в процессе работы с подарочными сертификатами
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура обработки выбора подарочного сертификата.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма.
//  ТекущиеДанные - Структура - Данные выбранного подарочного сертификата.
//  ТипКода - ПеречислениеСсылка.ТипыКодовКарт - Тип кода карты.
//
Процедура ОбработатьВыборПодарочногоСертификата(Форма, ТекущиеДанные, ТипКода) Экспорт
	
	ИдентификаторФормы = Форма.УникальныйИдентификатор;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		
		Оповестить(
			"СчитанПодарочныйСертификат",
			Новый Структура("ПодарочныйСертификат, ФормаВладелец", ТекущиеДанные.Ссылка, ИдентификаторФормы),
			Неопределено);
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Считан подарочный сертификат'"),
			ПолучитьНавигационнуюСсылку(ТекущиеДанные.Ссылка),
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Считан подарочный сертификат %1'"), ТекущиеДанные.Ссылка),
			БиблиотекаКартинок.Информация32);
		
	Иначе // Карта не зарегистрирована.
		
		ТекущиеДанные.Ссылка = ПодарочныеСертификатыВызовСервера.ЗарегистрироватьПодарочныйСертификатУпрощенно(ТекущиеДанные.ВидПодарочногоСертификата, ТипКода, ТекущиеДанные.МагнитныйКод, ТекущиеДанные.Штрихкод);
		
		Оповестить(
			"Запись_ПодарочныйСертификат",
			Новый Структура,
			ТекущиеДанные.Ссылка);
		
		Оповестить(
			"СчитанПодарочныйСертификат",
			Новый Структура("ПодарочныйСертификат, ФормаВладелец", ТекущиеДанные.Ссылка, ИдентификаторФормы),
			Неопределено);
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Считан подарочный сертификат'"),
			ПолучитьНавигационнуюСсылку(ТекущиеДанные.Ссылка),
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Считан подарочный сертификат %1'"), ТекущиеДанные.Ссылка),
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура выполняет обработку полученного кода подарочного сертификата.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма.
//  КодКарты - Строка - Полученный код подарочного сертификата.
//  ТипКода - ПеречислениеСсылка.ТипыКодов - Тип кода полученного подарочного сертификата.
//
Процедура ОбработатьПолученныйКодНаКлиенте(Форма, КодКарты, ТипКода) Экспорт
	
	Если  ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод")
		И ТипЗнч(КодКарты) = Тип("Массив") Тогда
		Предобработка = Истина;
	Иначе
		Предобработка = Ложь;
	КонецЕсли;
	
	НайденныеПодарочныеСертификаты = ПодарочныеСертификатыВызовСервера.ОбработатьПолученныйКодНаСервере(КодКарты, ТипКода, Предобработка);
	Если НайденныеПодарочныеСертификаты.Количество() = 0 Тогда
		
		Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
			ТекстСообщения = НСтр("ru = 'Подарочный сертификат со штрихкодом ""%1"" не зарегистрирован.'");
		Иначе
			Если Предобработка Тогда
				ТекстСообщения = НСтр("ru = 'Подарочный сертификат со считанным магнитным кодом не зарегистрирован.'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Подарочный сертификат с магнитным кодом ""%1"" не зарегистрирован.'");
			КонецЕсли;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, КодКарты));
		
		Возврат;
		
	КонецЕсли;
	
	Если НайденныеПодарочныеСертификаты.Количество() > 1 Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТипКода", ТипКода);
		ПараметрыОткрытия.Вставить("КодКарты", КодКарты);
		ОткрытьФорму("Справочник.ПодарочныеСертификаты.Форма.СчитываниеПодарочногоСертификата", ПараметрыОткрытия, Форма);
		
	ИначеЕсли НайденныеПодарочныеСертификаты.Количество() = 1 Тогда
		ПодарочныеСертификатыКлиент.ОбработатьВыборПодарочногоСертификата(Форма, НайденныеПодарочныеСертификаты[0], ТипКода);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
