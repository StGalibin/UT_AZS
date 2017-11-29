﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);

	Если ЗначениеЗаполнено(Запись.НоменклатураБрак) Тогда
		Запись.ГрадацияКачества = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.НоменклатураБрак, "Качество");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НоменклатураБракПриИзменении(Элемент)
	Запись.ГрадацияКачества = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Запись.НоменклатураБрак, "Качество");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

