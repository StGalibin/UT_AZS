﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Заголовок = НСтр("ru = 'Информация о синхронизации данных с 1С:Документооборот'");
	
	Макет = ПланыОбмена.ОбменУправлениеТорговлейДокументооборот.ПолучитьМакет("ПодробнаяИнформация");
	ПолеHTMLДокумента = Макет.ПолучитьТекст();

КонецПроцедуры
