﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УведомлениеОбИмпортеМаркированныхТоваровГИСМ") Тогда
		ЗаполнитьМаркировкуТоваровПоУведомлениюОбИмпортеМаркированныхТоваровГИСМ(ДанныеЗаполнения, ЭтотОбъект);
	КонецЕсли;
	
	МаркировкаТоваровГИСМПереопределяемый.ОбработкаЗаполненияМаркировкаТоваров(ДанныеЗаполнения, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ОперацияМаркировки = Перечисления.ОперацииМаркировкиГИСМ.ИдентификацияРанееМаркированнойНаПроизводствеПродукции
		ИЛИ ОперацияМаркировки = Перечисления.ОперацииМаркировкиГИСМ.ИдентификацияРанееМаркированныхПриИмпортеТоваров Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.НоменклатураКиЗ");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ХарактеристикаКиЗ");
		МассивНепроверяемыхРеквизитов.Добавить("КиЗГИСМВид");
		МассивНепроверяемыхРеквизитов.Добавить("КиЗГИСМСпособВыпускаВОборот");
		МассивНепроверяемыхРеквизитов.Добавить("КиЗГИСМРазмер");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КодТаможенногоОргана");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.ДатаРегистрацииДекларации");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.РегистрационныйНомерДекларации");
	
	Если Не ИнтеграцияГИСМ.ИспользоватьПодразделения() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Подразделение");
	КонецЕсли;
	
	Если ОперацияМаркировки = Перечисления.ОперацииМаркировкиГИСМ.МаркировкаОстатковНа12082016 Тогда
		
		Для каждого СтрокаТЧ Из Товары Цикл
			
			Если ЗначениеЗаполнено(СтрокаТЧ.КодТаможенногоОргана)
				Или ЗначениеЗаполнено(СтрокаТЧ.ДатаРегистрацииДекларации)
				Или ЗначениеЗаполнено(СтрокаТЧ.РегистрационныйНомерДекларации) Тогда
				
				НомерСтроки = СтрокаТЧ.НомерСтроки;
				
				Если Не ЗначениеЗаполнено(СтрокаТЧ.КодТаможенногоОргана) Тогда
					ТекстОшибки = НСтр("ru='В строке %НомерСтроки% списка ""Товары"" не указан ""Код таможенного органа"".'");
					ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", НомерСтроки);
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						ТекстОшибки,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", НомерСтроки, "КодТаможенногоОргана"),
						,
						Отказ);
				КонецЕсли;
				
				Если Не ЗначениеЗаполнено(СтрокаТЧ.ДатаРегистрацииДекларации) Тогда
					ТекстОшибки = НСтр("ru='В строке %НомерСтроки% списка ""Товары"" не указана ""Дата регистрации декларации"".'");
					ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", НомерСтроки);
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						ТекстОшибки,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", НомерСтроки, "ДатаРегистрацииДекларации"),
						,
						Отказ);
				КонецЕсли;
				
				Если Не ЗначениеЗаполнено(СтрокаТЧ.РегистрационныйНомерДекларации) Тогда
					ТекстОшибки = НСтр("ru='В строке %НомерСтроки% списка ""Товары"" не указан ""Регистрационный номер декларации"".'");
					ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", НомерСтроки);
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						ТекстОшибки,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", НомерСтроки, "РегистрационныйНомерДекларации"),
						,
						Отказ);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	МаркировкаТоваровГИСМПереопределяемый.ОбработкаПроверкиЗаполненияМаркировкаТоваров(Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов, ЭтотОбъект);
	
	МаркировкаТоваровГИСМ.ПроверитьСоответствияGTIN(ЭтотОбъект, Отказ);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МаркировкаТоваровГИСМПереопределяемый.ПередЗаписьюМаркировкаТоваров(Отказ, РежимЗаписи, РежимПроведения, ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	МаркировкаТоваровГИСМПереопределяемый.ПриКопированииМаркировкаТоваров(ОбъектКопирования, ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	МаркировкаТоваровГИСМПереопределяемый.ОбработкаПроведенияМаркировкаТоваров(Отказ, РежимПроведения, ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	МаркировкаТоваровГИСМПереопределяемый.ОбработкаУдаленияПроведенияМаркировкаТоваров(Отказ, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура ЗаполнитьМаркировкуТоваровПоУведомлениюОбИмпортеМаркированныхТоваровГИСМ(ДанныеЗаполнения, ДокументОбъект)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	УведомлениеОбИмпорте.Ссылка КАК Ссылка,
	|	УведомлениеОбИмпорте.Организация КАК Организация
	|ИЗ
	|	Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ КАК УведомлениеОбИмпорте
	|ГДЕ
	|	УведомлениеОбИмпорте.Ссылка = &Ссылка
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УведомлениеОбИмпортеТовары.Номенклатура,
	|	УведомлениеОбИмпортеТовары.Характеристика,
	|	УведомлениеОбИмпортеТовары.Количество
	|ИЗ
	|	Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Товары КАК УведомлениеОбИмпортеТовары
	|ГДЕ
	|	УведомлениеОбИмпортеТовары.Ссылка = &Ссылка
	|");
	
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.Ссылка);
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаШапка = Результат[0].Выбрать();
	ВыборкаШапка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ДокументОбъект, ВыборкаШапка);
	ДокументОбъект.ОперацияМаркировки = Перечисления.ОперацииМаркировкиГИСМ.МаркировкаИмпортированныхТоваров;
	ДокументОбъект.Основание = ДанныеЗаполнения.Ссылка;
	
	ДокументОбъект.Товары.Загрузить(Результат[1].Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
