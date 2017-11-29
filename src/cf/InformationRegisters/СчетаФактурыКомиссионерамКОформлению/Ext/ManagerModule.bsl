﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Переформировывает распоряжения на оформления счетов-фактур комиссионерам.
//
// Параметры:
// 	 ОтчетыКомиссионеров - Массив - Отчеты по комиссии, по которым необходимо выполнить формирование распоряжений.
// 
Процедура ОбновитьСостояние(ОтчетыКомиссионеров) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.ОтчетКомиссионера,
	|	ВложенныйЗапрос.Покупатель,
	|	ВложенныйЗапрос.ДатаСчетаФактуры,
	|	ВложенныйЗапрос.НомерСчетаФактуры,
	|	СУММА(ВложенныйЗапрос.СуммаСНДС) КАК СуммаСНДС,
	|	СУММА(ВложенныйЗапрос.СуммаНДС) КАК СуммаНДС,
	|	ВложенныйЗапрос.Организация,
	|	ВложенныйЗапрос.Комиссионер,
	|	ВложенныйЗапрос.Валюта
	|ПОМЕСТИТЬ СчетаФакутурыКомиссионеруКРегистрации
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОтчетКомиссионера.Организация КАК Организация,
	|		ОтчетКомиссионера.Ссылка КАК ОтчетКомиссионера,
	|		ОтчетКомиссионера.Контрагент КАК Комиссионер,
	|		ТаблицаТовары.Покупатель КАК Покупатель,
	|		НАЧАЛОПЕРИОДА(ТаблицаТовары.ДатаСчетаФактурыКомиссионера, ДЕНЬ) КАК ДатаСчетаФактуры, 
	|		ТаблицаТовары.НомерСчетаФактурыКомиссионера КАК НомерСчетаФактуры,  
	|		ТаблицаТовары.СуммаПродажи КАК СуммаСНДС,
	|		ТаблицаТовары.СуммаПродажиНДС КАК СуммаНДС,
	|		ОтчетКомиссионера.Валюта КАК Валюта
	|	ИЗ
	|		Документ.ОтчетКомиссионера КАК ОтчетКомиссионера
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			Документ.ОтчетКомиссионера.Товары КАК ТаблицаТовары
	|		ПО
	|			ОтчетКомиссионера.Ссылка = ТаблицаТовары.Ссылка
	|	ГДЕ
	|		ОтчетКомиссионера.Ссылка В (&Ссылки)
	|		И ОтчетКомиссионера.Проведен
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ОтчетКомиссионера.Организация КАК Организация,
	|		ОтчетКомиссионера.Ссылка КАК ОтчетКомиссионера,
	|		ОтчетКомиссионера.Комиссионер КАК Комиссионер,
	|		ТаблицаТовары.Покупатель КАК Покупатель,
	|		НАЧАЛОПЕРИОДА(ТаблицаТовары.ДатаСчетаФактурыКомиссионера, ДЕНЬ) КАК ДатаСчетаФактуры, 
	|		ЕСТЬNULL(ТаблицаТовары.СчетФактураВыставленныйКомиссионера.Номер, """") КАК НомерСчетаФактуры,
	|		ТаблицаТовары.СуммаПродажи КАК СуммаСНДС,
	|		ТаблицаТовары.СуммаПродажиНДС КАК СуммаНДС,
	|		ОтчетКомиссионера.Валюта КАК Валюта
	|	ИЗ
	|		Документ.ОтчетПоКомиссииМеждуОрганизациями КАК ОтчетКомиссионера
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			Документ.ОтчетПоКомиссииМеждуОрганизациями.Товары КАК ТаблицаТовары
	|		ПО
	|			ОтчетКомиссионера.Ссылка = ТаблицаТовары.Ссылка
	|	ГДЕ
	|		ОтчетКомиссионера.Ссылка В (&Ссылки)
	|		И ОтчетКомиссионера.Проведен) КАК ВложенныйЗапрос
	|	
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Организация,
	|	ВложенныйЗапрос.ОтчетКомиссионера,
	|	ВложенныйЗапрос.Комиссионер,
	|	ВложенныйЗапрос.Покупатель,
	|	ВложенныйЗапрос.ДатаСчетаФактуры,
	|	ВложенныйЗапрос.НомерСчетаФактуры,
	|	ВложенныйЗапрос.Валюта
	|	
	|ИНДЕКСИРОВАТЬ ПО
	|	ОтчетКомиссионера,
	|	Покупатель,
	|	ДатаСчетаФактуры,
	|	НомерСчетаФактуры
	|;
	|
	|ВЫБРАТЬ
	|	СчетФактураКомиссионеру.Ссылка КАК Ссылка,
	|	СчетФактураКомиссионеру.Организация КАК Организация,
	|	СчетФактураКомиссионеру.ДокументОснование КАК ОтчетКомиссионера,
	|	СчетФактураКомиссионеру.Комиссионер КАК Комиссионер,
	|	ТаблицаПокупатели.Покупатель КАК Покупатель,
	|	НАЧАЛОПЕРИОДА(СчетФактураКомиссионеру.Дата, ДЕНЬ) КАК ДатаСчетаФактуры,
	|	ТаблицаПокупатели.НомерСчетаФактуры КАК НомерСчетаФактуры,
	|	СчетФактураКомиссионеру.Валюта КАК Валюта
	|ПОМЕСТИТЬ СчетаФактурыКомиссионеру
	|ИЗ
	|	Документ.СчетФактураКомиссионеру КАК СчетФактураКомиссионеру
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.СчетФактураКомиссионеру.Покупатели КАК ТаблицаПокупатели
	|	ПО
	|		СчетФактураКомиссионеру.Ссылка = ТаблицаПокупатели.Ссылка
	|ГДЕ
	|	СчетФактураКомиссионеру.ДокументОснование В (&Ссылки)
	|	И СчетФактураКомиссионеру.Проведен
	|	
	|ИНДЕКСИРОВАТЬ ПО
	|	ОтчетКомиссионера,
	|	Покупатель,
	|	ДатаСчетаФактуры,
	|	НомерСчетаФактуры
	|;
	|
	|ВЫБРАТЬ
	|	КРегистрации.ОтчетКомиссионера,
	|	КРегистрации.Комиссионер,
	|	КРегистрации.Организация,
	|	КРегистрации.Покупатель,
	|	КРегистрации.ДатаСчетаФактуры,
	|	КРегистрации.НомерСчетаФактуры,
	|	КРегистрации.Валюта,
	|	КРегистрации.СуммаСНДС,
	|	КРегистрации.СуммаНДС
	|ИЗ
	|	СчетаФакутурыКомиссионеруКРегистрации КАК КРегистрации
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		СчетаФактурыКомиссионеру КАК СчетаФактурыКомиссионеру
	|	ПО
	|		КРегистрации.ОтчетКомиссионера = СчетаФактурыКомиссионеру.ОтчетКомиссионера
	|		И КРегистрации.Покупатель = СчетаФактурыКомиссионеру.Покупатель
	|		И КРегистрации.НомерСчетаФактуры = СчетаФактурыКомиссионеру.НомерСчетаФактуры
	|		И (КРегистрации.ДатаСчетаФактуры = СчетаФактурыКомиссионеру.ДатаСчетаФактуры
	|			ИЛИ КРегистрации.ДатаСчетаФактуры = &ПустаяДата)
	|ГДЕ
	|	СчетаФактурыКомиссионеру.Ссылка ЕСТЬ NULL
	|";
	Запрос.УстановитьПараметр("Ссылки", ОтчетыКомиссионеров);
	Запрос.УстановитьПараметр("ПустаяДата", Дата(1,1,1));
	
	СчетаФактурыКомиссионерамКОформлению = Запрос.Выполнить().Выгрузить(); 
	СчетаФактурыКомиссионерамКОформлению.Индексы.Добавить("ОтчетКомиссионера");
	
	Для каждого ОтчетКомиссионера Из ОтчетыКомиссионеров Цикл
		НаборЗаписей = РегистрыСведений.СчетаФактурыКомиссионерамКОформлению.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ОтчетКомиссионера.Установить(ОтчетКомиссионера);
		Строки = СчетаФактурыКомиссионерамКОформлению.НайтиСтроки(Новый Структура("ОтчетКомиссионера", ОтчетКомиссионера));
		Для каждого Строка Из Строки Цикл
			Запись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, Строка);
		КонецЦикла;
		НаборЗаписей.Записывать = Истина;
		НаборЗаписей.Записать();
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли