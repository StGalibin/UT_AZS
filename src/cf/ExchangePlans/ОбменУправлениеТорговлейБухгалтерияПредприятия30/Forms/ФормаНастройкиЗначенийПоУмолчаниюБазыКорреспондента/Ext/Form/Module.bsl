﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПланаОбмена = Метаданные.ПланыОбмена.ОбменУправлениеТорговлейБухгалтерияПредприятия30.Имя;
	
	ОбменДаннымиСервер.ФормаНастройкиЗначенийПоУмолчаниюБазыКорреспондентаПриСозданииНаСервере( ЭтаФорма, 
																								ИмяПланаОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбменДаннымиКлиент.ОбработчикВыбораЭлементовБазыКорреспондентаОбработкаВыбора(ЭтаФорма, ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НоменклатурнаяГруппаПоУмолчаниюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикВыбораЭлементовБазыКорреспондентаНачалоВыбора( "НоменклатурнаяГруппаПоУмолчанию", 
																				"Справочник.НоменклатурныеГруппы", 
																				ЭтаФорма, 
																				СтандартнаяОбработка, 
																				ПараметрыВнешнегоСоединения);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяПрочихДоходовРасходов_ОприходованиеТоваровНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикВыбораЭлементовБазыКорреспондентаНачалоВыбора( "СтатьяПрочихДоходовРасходов_ОприходованиеТоваров", 
																				"Справочник.ПрочиеДоходыИРасходы", 
																				ЭтаФорма, 
																				СтандартнаяОбработка, 
																				ПараметрыВнешнегоСоединения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ОбменДаннымиКлиент.ФормаНастройкиЗначенийПоУмолчаниюКомандаЗакрытьФорму(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
