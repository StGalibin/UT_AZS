﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отбор = Новый Структура("Ячейка", ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Отбор);
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "ПоЯчейкеКонтекст");
	ПараметрыФормы.Вставить("КлючВарианта", "ПоЯчейкеКонтекст");
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("ВидимостьКомандВариантовОтчетов", Ложь);
	
	ОткрытьФорму("Отчет.ТоварыВЯчейках.Форма",
			ПараметрыФормы,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти