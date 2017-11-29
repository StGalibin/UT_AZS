﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Заголовок = Параметры.Заголовок;
	Значение = Параметры.Значение;
	ВидСравнения = ?(ЗначениеЗаполнено(Параметры.ОператорСравнения), Параметры.ОператорСравнения, ">=");
	Если ЗначениеЗаполнено(Параметры.ОператорСравнения2) Тогда
		ВидСравнения = "Между";
		Значение2 = Параметры.Значение2;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийРеквизитовФормы

&НаКлиенте
Процедура ВидСравненияПриИзменении(Элемент)
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыполнитьВыбор(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Искать(Команда)
	
	ВыполнитьВыбор(Истина);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступность()
	
	Элементы.ЗначениеРавно.Доступность = (ВидСравнения = "=");
	Элементы.ЗначениеОт.Доступность = (ВидСравнения = ">=");
	Элементы.ЗначениеПо.Доступность = (ВидСравнения = "<=");
	Элементы.ЗначениеМеждуОт.Доступность = (ВидСравнения = "Между");
	Элементы.ЗначениеМеждуПо.Доступность = (ВидСравнения = "Между");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыбор(НайтиСразу)
	
	Результат = Новый Структура;
	Результат.Вставить("Значение", Значение);
	Если ВидСравнения = "Между" Тогда
		Если Значение2 < Значение Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Проверьте введенные значения: левая дата позже правой.'"));
			Возврат;
		КонецЕсли;
		Результат.Вставить("ОператорСравнения", ">=");
		Результат.Вставить("Значение2", Значение2);
		Результат.Вставить("ОператорСравнения2", "<=");
	Иначе
		Результат.Вставить("ОператорСравнения", ВидСравнения);
		Результат.Вставить("ОператорСравнения2", "");
	КонецЕсли;
	Результат.Вставить("НайтиСразу", НайтиСразу);
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

