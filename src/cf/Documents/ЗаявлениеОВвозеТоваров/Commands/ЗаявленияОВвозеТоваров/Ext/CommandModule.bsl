﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(ИмяФормыЗаявленияОВвозеТоваров(), 
		, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ИмяФормыЗаявленияОВвозеТоваров()
	Возврат Документы.ЗаявлениеОВвозеТоваров.ИмяФормыЗаявленияОВвозеТоваров();
КонецФункции

#КонецОбласти


