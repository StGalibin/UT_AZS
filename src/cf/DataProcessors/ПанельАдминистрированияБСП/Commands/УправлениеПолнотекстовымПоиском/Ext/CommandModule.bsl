﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПолнотекстовыйПоиск") Тогда
		ИмяОткрываемойФормы = "Обработка.ПанельАдминистрированияБСП.Форма.УправлениеПолнотекстовымПоискомИИзвлечениемТекстов";
		ОткрытьФорму(ИмяОткрываемойФормы, , ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти