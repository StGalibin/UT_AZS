﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ВосстановитьНастройки();
	
	Если НЕ ЗначениеЗаполнено(ПортTCPIP) Тогда
		ПортTCPIP = 2003;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(COMПорт) Тогда
		COMПорт = 1;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИмяСервисаIRDA) Тогда
		ИмяСервисаIRDA = "S1C8";
	КонецЕсли;
	
	СтрокаИнформации = НСтр("ru='Настройки действуют для пользователя %ТекущийПользователь%'");
	ИнформацияОПринадлежностиНастроек = 
		СтрЗаменить(СтрокаИнформации, "%ТекущийПользователь%", Пользователи.ТекущийПользователь());
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВестиЖурналСобытийПриИзменении(Элемент)
	
	Элементы.КаталогЖурналаСобытий.Доступность = ВестиЖурналСобытий;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьTCPIPПриИзменении(Элемент)
	
	Элементы.ПортTCPIP.Доступность = ИспользоватьTCPIP;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьIRDAПриИзменении(Элемент)
	
	Элементы.ИмяСервисаIRDA.Доступность = ИспользоватьIRDA;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьCOMпортПриИзменении(Элемент)
	
	Элементы.COMПорт.Доступность = ИспользоватьCOMпорт;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогЖурналаСобытийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораФайла.Каталог = КаталогЖурналаСобытий;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"КаталогЖурналаСобытийВыборКаталога",
		ЭтотОбъект);
	
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогЖурналаСобытийВыборКаталога(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КаталогЖурналаСобытий = ВыбранныеФайлы[0];
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если глКомпонентаОбменаСМобильнымиПриложениями <> Неопределено Тогда
		
		ТекстСообщения = НСтр("ru='Компонента обмена подключена. Установить новые параметры для подключенной компоненты?'");
		Ответ = Неопределено;

		ПоказатьВопрос(Новый ОписаниеОповещения("СохранитьЗавершение", ЭтотОбъект), ТекстСообщения, РежимДиалогаВопрос.ДаНет);
        Возврат;
		
	КонецЕсли;
	
	СохранитьФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Да Тогда
        
        глКомпонентаОбменаСМобильнымиПриложениями.ВестиЖурналСобытий = ВестиЖурналСобытий;
        глКомпонентаОбменаСМобильнымиПриложениями.КаталогЖурналаСобытий = КаталогЖурналаСобытий;
        
        Если ИспользоватьTCPIP Тогда
            глКомпонентаОбменаСМобильнымиПриложениями.ПодключитьTCPIP(ПортTCPIP);
        Иначе
            глКомпонентаОбменаСМобильнымиПриложениями.Отключить(1);	
        КонецЕсли;
        
        Если ИспользоватьIRDA Тогда
            глКомпонентаОбменаСМобильнымиПриложениями.ПодключитьIRDA(ИмяСервисаIRDA);
        Иначе
            глКомпонентаОбменаСМобильнымиПриложениями.Отключить(3);	
        КонецЕсли;
        
        Если ИспользоватьCOMПорт Тогда
            глКомпонентаОбменаСМобильнымиПриложениями.ПодключитьCOMПорт(COMПорт);
        Иначе
            глКомпонентаОбменаСМобильнымиПриложениями.Отключить(4);
        КонецЕсли;
        
    КонецЕсли;
    
    
    СохранитьФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура СохранитьФрагмент()
    
    СохранитьНастройки();
    Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СохранитьНастройки()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиРаботыПользователяСКомпонентойОбменаДанными", "ВестиЖурналСобытий", ВестиЖурналСобытий);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиРаботыПользователяСКомпонентойОбменаДанными","КаталогЖурналаСобытий", КаталогЖурналаСобытий);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиРаботыПользователяСКомпонентойОбменаДанными","ИспользоватьTCPIP", ИспользоватьTCPIP);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиРаботыПользователяСКомпонентойОбменаДанными","ИспользоватьIRDA", ИспользоватьIRDA);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиРаботыПользователяСКомпонентойОбменаДанными","ИспользоватьCOMПорт", ИспользоватьCOMпорт);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиРаботыПользователяСКомпонентойОбменаДанными","ПортTCPIP", ПортTCPIP);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиРаботыПользователяСКомпонентойОбменаДанными","ИмяСервисаIRDA", ИмяСервисаIRDA);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиРаботыПользователяСКомпонентойОбменаДанными","COMПорт", COMПорт);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиРаботыПользователяСКомпонентойОбменаДанными",
										"ПодключатьКомпонентуОбменаДаннымиПриСтартеСистемы", ПодключатьКомпонентуОбменаДаннымиПриСтартеСистемы);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()
	
	УстановитьЗначениеНастройки("ВестиЖурналСобытий", ВестиЖурналСобытий);
	УстановитьЗначениеНастройки("КаталогЖурналаСобытий", КаталогЖурналаСобытий);
	УстановитьЗначениеНастройки("ИспользоватьTCPIP", ИспользоватьTCPIP);
	УстановитьЗначениеНастройки("ИспользоватьIRDA", ИспользоватьIRDA);
	УстановитьЗначениеНастройки("ИспользоватьCOMПорт", ИспользоватьCOMпорт);
	УстановитьЗначениеНастройки("ПортTCPIP", ПортTCPIP);
	УстановитьЗначениеНастройки("ИмяСервисаIRDA", ИмяСервисаIRDA);
	УстановитьЗначениеНастройки("COMПорт", COMПорт);
	УстановитьЗначениеНастройки("ПодключатьКомпонентуОбменаДаннымиПриСтартеСистемы", ПодключатьКомпонентуОбменаДаннымиПриСтартеСистемы);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеНастройки(ИмяНастройки, Настройка)
	
	ЗначениеНастройкиИзХранилища = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиРаботыПользователяСКомпонентойОбменаДанными", ИмяНастройки);
	Если ЗначениеНастройкиИзХранилища <> Неопределено Тогда
		Настройка = ЗначениеНастройкиИзХранилища;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов()
	
	Элементы.ПортTCPIP.Доступность = ИспользоватьTCPIP;
	Элементы.ИмяСервисаIRDA.Доступность = ИспользоватьIRDA;
	Элементы.COMПорт.Доступность = ИспользоватьCOMпорт;
	Элементы.КаталогЖурналаСобытий.Доступность = ВестиЖурналСобытий;
	
КонецПроцедуры

#КонецОбласти
