﻿#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыКлиента.Свойство("ИнформацияПриЗапуске") И ПараметрыКлиента.ИнформацияПриЗапуске.Показывать Тогда
		ПодключитьОбработчикОжидания("ПоказатьИнформациюПослеЗапуска", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается из обработчика ожидания, открывает окно информации.
Процедура Показать() Экспорт
	
КонецПроцедуры

#КонецОбласти
