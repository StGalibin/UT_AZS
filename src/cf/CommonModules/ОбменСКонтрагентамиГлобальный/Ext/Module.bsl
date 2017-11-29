﻿////////////////////////////////////////////////////////////////////////////////
// ОбменСКонтрагентамиГлобальный: механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Выводит сообщение о наличии новых электронных документов
// в сервисе 1С-ЭДО.
Процедура ОповеститьОНовыхЭД() Экспорт
	
	ЕстьСобытияЭДО = ОбменСКонтрагентамиСлужебныйВызовСервера.ЕстьСобытияЭДО();
	
	Если ЕстьСобытияЭДО Тогда
		
		ОбменСКонтрагентамиКлиент.ОповеститьОНовыхДокументахЭДО();
		
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОповеститьОНовыхЭД", 3600, Истина);
	
КонецПроцедуры

#КонецОбласти
