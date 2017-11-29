﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обработчик обновления на БЭД 1.3.6.7
// Заполняет реквизиты табличных частей справочников "Профили настроек ЭДО"
// и "Соглашение об использовании ЭДО".
//
Процедура ЗаполнитьРегламентЭДО() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрофилиНастроекЭДО.Ссылка КАК Профиль,
	|	ПрофилиНастроекЭДО.ИспользоватьУПД,
	|	ПрофилиНастроекЭДО.ИспользоватьУКД
	|ИЗ
	|	Справочник.ПрофилиНастроекЭДО КАК ПрофилиНастроекЭДО";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Профиль = Выборка.Профиль;
		ПрофильОбъект = Профиль.ПолучитьОбъект();
		ИсходящиеДокументы = ПрофильОбъект.ИсходящиеДокументы;
		Для Каждого ТекСтрока Из ИсходящиеДокументы Цикл
			
			ТекСтрока.ТребуетсяИзвещениеОПолучении = Истина;
			
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.СчетФактура Тогда
				
				Если Выборка.ИспользоватьУПД Тогда
					ТекСтрока.ТребуетсяОтветнаяПодпись = Истина;
					
				Иначе
					ТекСтрока.ТребуетсяОтветнаяПодпись = Ложь;
				КонецЕсли;
			ИначеЕсли ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.КорректировочныйСчетФактура Тогда
				Если Выборка.ИспользоватьУКД Тогда
					ТекСтрока.ТребуетсяОтветнаяПодпись = Истина;
					
				Иначе
					ТекСтрока.ТребуетсяОтветнаяПодпись = Ложь;
				КонецЕсли;
				
			ИначеЕсли ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.СчетНаОплату Тогда
				
				ТекСтрока.ТребуетсяОтветнаяПодпись = Ложь;
				
			Иначе
				ТекСтрока.ТребуетсяОтветнаяПодпись = ТекСтрока.ИспользоватьЭП;
				
			КонецЕсли;
		КонецЦикла;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ПрофильОбъект);
		
		ПрофильОбъект.ИзменитьДанныеВСвязанныхНастройкахЭДО(ПрофильОбъект, Ложь);
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка КАК Настройка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	СоглашенияОбИспользованииЭД.РасширенныйРежимНастройкиСоглашения = ИСТИНА";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Соглашение = Выборка.Настройка;
		СоглашениеОбъект = Соглашение.ПолучитьОбъект();
		Для Каждого ТекСтрока Из СоглашениеОбъект.ИсходящиеДокументы Цикл
			
			ВидЭД = ТекСтрока.ИсходящийДокумент;
			ПрофильЭДО = ТекСтрока.ПрофильНастроекЭДО;
			
			СвойстваЭД = Новый Структура("ТребуетсяИзвещение, ТребуетсяОтветнаяПодпись, ИспользоватьЭП");
			ЗаполнитьСвойстваЭДИзПрофиля(ПрофильЭДО, ВидЭД, СвойстваЭД);
			
			ЗаполнитьЗначенияСвойств(ТекСтрока, СвойстваЭД);
			
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СоглашениеОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.3.6.25
Процедура СнятьФлагОтветнойПодписиУСчетаНаОплату() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка КАК ПрофильЭДО
	|ИЗ
	|	Справочник.ПрофилиНастроекЭДО.ИсходящиеДокументы КАК ПрофилиНастроекЭДОИсходящиеДокументы
	|ГДЕ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ИсходящийДокумент = ЗНАЧЕНИЕ(Перечисление.ВидыЭД.СчетНаОплату)
	|	И ПрофилиНастроекЭДОИсходящиеДокументы.ТребуетсяОтветнаяПодпись = ИСТИНА";
	
	Результат = Запрос.Выполнить();
	
	ИсходящийДокументСчетНаОплату = Перечисления.ВидыЭД.СчетНаОплату;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПрофильОбъект = Выборка.ПрофильЭДО.ПолучитьОбъект();
		ИсходящиеДокументыПрофиля = ПрофильОбъект.ИсходящиеДокументы;
		
		СтрокаСчетНаОплату = ИсходящиеДокументыПрофиля.Найти(ИсходящийДокументСчетНаОплату, "ИсходящийДокумент");
		СтрокаСчетНаОплату.ТребуетсяОтветнаяПодпись = Ложь;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ПрофильОбъект);
		
		ПрофильОбъект.ИзменитьДанныеВСвязанныхНастройкахЭДО(ПрофильОбъект, Ложь);
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка КАК НастройкаЭДО
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД.ИсходящиеДокументы КАК СоглашенияОбИспользованииЭДИсходящиеДокументы
	|ГДЕ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.ИсходящийДокумент = ЗНАЧЕНИЕ(Перечисление.ВидыЭД.СчетНаОплату)
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.РасширенныйРежимНастройкиСоглашения = ИСТИНА";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НастройкаЭДООбъект = Выборка.НастройкаЭДО.ПолучитьОбъект();
		ИсходящиеДокументыНастройки = НастройкаЭДООбъект.ИсходящиеДокументы;
		
		СтрокаСчетНаОплатуНастройки = ИсходящиеДокументыНастройки.Найти(ИсходящийДокументСчетНаОплату, "ИсходящийДокумент");
		СтрокаСчетНаОплатуНастройки.ТребуетсяОтветнаяПодпись = Ложь;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НастройкаЭДООбъект);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСвойстваЭДИзПрофиля(ПрофильЭДО, ВидЭД, СвойстваЭД)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ТребуетсяИзвещениеОПолучении КАК ТребуетсяИзвещение,
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ТребуетсяОтветнаяПодпись КАК ТребуетсяОтветнаяПодпись,
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ИспользоватьЭП КАК ИспользоватьЭП
	|ИЗ
	|	Справочник.ПрофилиНастроекЭДО.ИсходящиеДокументы КАК ПрофилиНастроекЭДОИсходящиеДокументы
	|ГДЕ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка = &ПрофильЭДО
	|	И ПрофилиНастроекЭДОИсходящиеДокументы.ИсходящийДокумент = &ВидЭД";
	
	Запрос.УстановитьПараметр("ПрофильЭДО", ПрофильЭДО);
	Запрос.УстановитьПараметр("ВидЭД", ВидЭД);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СвойстваЭД, Выборка);
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
