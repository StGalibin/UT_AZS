﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПутьКПапкеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	
	Диалог.Заголовок                    = НСтр("ru = 'Выберите каталог'");
	Диалог.МножественныйВыбор           = Ложь;
	Диалог.ПредварительныйПросмотр      = Ложь;
	
	Если Диалог.Выбрать() Тогда
		
		НаборКонстант[Элемент.Имя] = Диалог.Каталог;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

