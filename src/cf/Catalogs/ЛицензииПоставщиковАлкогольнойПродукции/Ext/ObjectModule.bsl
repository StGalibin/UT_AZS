﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнитьДатыНачалаОкончания();
	Наименование = "";
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнитьДатыНачалаОкончания();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДатыНачалаОкончания()
	
	ДатаНачала = ТекущаяДатаСеанса();
	Если ДатаОкончания < ДатаНачала Тогда
		ДатаОкончания = Дата(1,1,1);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
