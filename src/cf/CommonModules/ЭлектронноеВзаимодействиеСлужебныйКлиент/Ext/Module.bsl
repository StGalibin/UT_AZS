﻿
////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеСлужебныйКлиент: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Выводит пользователю информацию об обработанных электронных документах.
//
// Параметры:
//  ТекстЗаголовка - Строка - текст заголовка оповещения пользователя;
//  КолСформированных - Число - количество сформированных электронных документов;
//  КолУтвержденных - Число -  количество утвержденных электронных документов;
//  КолПодписанных - Число -  количество подписанных электронных документов;
//  КолПодготовленных - Число -  количество подготовленных к отправке электронных документов;
//  КолОтправленных - Число - количество отправленных электронных документов.
//
Процедура ВывестиИнформациюОбОбработанныхЭД(ТекстЗаголовка, КолСформированных, КолУтвержденных, КолПодписанных, КолПодготовленных, КолОтправленных = 0) Экспорт
	
	Если КолПодготовленных + КолОтправленных > 0 Тогда
		ДопТекст = ?(КолОтправленных > 0, НСтр("ru = 'отправлено'"), НСтр("ru = 'подготовлено к отправке'"));
		Количество = ?(КолОтправленных > 0, КолОтправленных, КолПодготовленных);
		Если КолПодписанных > 0 Тогда
			Если КолУтвержденных > 0 Тогда
				Если КолСформированных > 0 Тогда
					Текст = НСтр("ru = 'Сформировано: (%1), утверждено: (%2), подписано: (%3), %4 пакетов: (%5)'");
					Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КолСформированных, КолУтвержденных,
						КолПодписанных, ДопТекст, Количество);
				Иначе
					Текст = НСтр("ru = 'Утверждено: (%1), подписано: (%2), %3 пакетов: (%4)'");
					Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КолУтвержденных, КолПодписанных, ДопТекст,
						Количество);
				КонецЕсли;
			Иначе
				Текст = НСтр("ru = 'Подписано: (%1), %2 пакетов: (%3)'");
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КолПодписанных, ДопТекст, Количество);
			КонецЕсли;
		Иначе
			Если КолУтвержденных > 0 Тогда
				Если КолСформированных > 0 Тогда
					Текст = НСтр("ru = 'Сформировано: (%1), утверждено: (%2), %3 пакетов: (%4)'");
					Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КолСформированных,
						КолУтвержденных, ДопТекст, КолПодготовленных);
				Иначе
					Текст = НСтр("ru = 'Утверждено: (%1), %2 пакетов: (%3)'");
					Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КолУтвержденных, ДопТекст, КолПодготовленных);
				КонецЕсли;
			Иначе
				Текст = НСтр("ru = '%1 пакетов: (%2)'");
				Количество = Макс(КолПодготовленных, КолОтправленных);
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, ДопТекст, Количество);
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если КолПодписанных > 0 Тогда
			Если КолУтвержденных > 0 Тогда
				Если КолСформированных > 0 Тогда
					Текст = НСтр("ru = 'Сформировано: (%1), утверждено: (%2), подписано: (%3)'");
					Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КолСформированных, КолУтвержденных,
						КолПодписанных);
				Иначе
					Текст = НСтр("ru = 'Утверждено: (%1), подписано: (%2)'");
					Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КолУтвержденных, КолПодписанных);
				КонецЕсли;
			Иначе
				Текст = НСтр("ru = 'Подписано: (%1)'");
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КолПодписанных);
			КонецЕсли;
		Иначе
			Если КолУтвержденных > 0 Тогда
				Если КолСформированных > 0 Тогда
					Текст = НСтр("ru = 'Сформировано: (%1), утверждено: (%2)'");
					Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КолСформированных, КолУтвержденных);
				Иначе
					Текст = НСтр("ru = 'Утверждено: (%1)'");
					Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КолУтвержденных);
				КонецЕсли;
			Иначе
				Если КолСформированных > 0 Тогда
					Текст = НСтр("ru = 'Сформировано: (%1)'");
					Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КолСформированных);
				Иначе
					Текст = НСтр("ru = 'Обработанных документов нет...'");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ТекстЗаголовка, ,Текст);
	
КонецПроцедуры

// Выводит сообщение пользователю о нехватке прав доступа.
Процедура СообщитьПользователюОНарушенииПравДоступа() Экспорт
	
	ОчиститьСообщения();
	ТекстСообщения = НСтр("ru = 'Нарушение прав доступа.'");
	ЭлектронноеВзаимодействиеКлиентПереопределяемый.ПодготовитьТекстСообщенияОНарушенииПравДоступа(ТекстСообщения);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

// Функция получает массив ссылок на объекты.
//
// Параметры:
//  ПараметрКоманды - ссылка на объект или массив.
//
// Возвращаемое значение:
//  МассивСсылок - если передан в параметр массив, то возвращает его же
//                 если передана пустая ссылка возвращает неопределено.
//
Функция МассивПараметров(ПараметрКоманды) Экспорт
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		Если ПараметрКоманды.Количество() = 0 Тогда
			Возврат Неопределено;
		КонецЕсли;
		МассивСсылок = ПараметрКоманды;
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("ВыделенныеСтрокиТабличногоПоля") Тогда
			МассивСсылок = Новый Массив;
			Для Каждого Элемент Из ПараметрКоманды Цикл
				МассивСсылок.Добавить(Элемент);
			КонецЦикла
	#КонецЕсли
	Иначе // пришла единичная ссылка на объект
		Если НЕ ЗначениеЗаполнено(ПараметрКоманды) Тогда
			Возврат Неопределено;
		КонецЕсли;
		МассивСсылок = Новый Массив;
		МассивСсылок.Добавить(ПараметрКоманды);
	КонецЕсли;
	
	Возврат МассивСсылок;
	
КонецФункции

// Осуществляет подсчет количество подписанных электронных документов.
// 
// Параметры:
//   РезультатВыполнения - Структура - возвращает метод ЭлектроннаяПодписьКлиент.Подписать.
//
// Возвращаемое значение:
//    Число - количество подписанных документов.
//
Функция КоличествоПодписанныхЭД(РезультатВыполнения) Экспорт
	
	КолВоПодписанных = 0;
	
	НаборДанных = Неопределено;
	РезультатВыполнения.Свойство("НаборДанных", НаборДанных);
	Если НаборДанных = Неопределено Тогда
		Возврат КолВоПодписанных;
	КонецЕсли;
	
	Успех = Неопределено;
	РезультатВыполнения.Свойство("Успех", Успех);
	Если Успех = Неопределено Тогда
		Возврат КолВоПодписанных;
	КонецЕсли;
	
	Если Успех Тогда
		КолВоПодписанных = НаборДанных.Количество();
		Возврат КолВоПодписанных;
	КонецЕсли;
	
	// Если в во входящих параметрах свойство "Успех" ложь,
	// то посчитаем кол-во подписанных ЭД
	// если из 3 переданных ЭД подписали 2.
	Для Каждого ЭлементМассива Из НаборДанных Цикл
		Если ЭлементМассива.Свойство("СтруктураПодписи") Тогда
			КолВоПодписанных = КолВоПодписанных + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат КолВоПодписанных;
	
КонецФункции

// Обработчик асинхронных процедур, для которых не требуется обрабатывать результаты.
Процедура ПустойОбработчик(РезультатВызова, ДополнительныеПараметры = Неопределено) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получение ссылок объектов из формы
//
// Параметры:
//  Источник - ТаблицаФормы, Объект - данные формы.
//
// Возвращаемое значение:
//  Массив - ссылки на объекты.
//
Функция ОбъектыОснований(Источник)
	
	Результат = Новый Массив;
	
	Если ТипЗнч(Источник) = Тип("ТаблицаФормы") Тогда
		ВыделенныеСтроки = Источник.ВыделенныеСтроки;
		Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				Продолжить;
			КонецЕсли;
			ТекущаяСтрока = Источник.ДанныеСтроки(ВыделеннаяСтрока);
			Если ТекущаяСтрока <> Неопределено Тогда
				Результат.Добавить(ТекущаяСтрока.Ссылка);
			КонецЕсли;
		КонецЦикла;
	Иначе
		Результат.Добавить(Источник.Ссылка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Выполнение команды после подтверждения записи
//
// Параметры:
//  РезультатВопроса - КодВозвратаДиалога - результат вопроса.
//  ДополнительныеПараметры - Структура - параметры выполняемой команды.
//
Процедура ВыполнитьПодключаемуюКомандуЭДОПодтверждениеЗаписи(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОписаниеКоманды = ДополнительныеПараметры.ОписаниеКоманды;
	Форма = ДополнительныеПараметры.Форма;
	Источник = ДополнительныеПараметры.Источник;
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		Форма.Записать();
		Если Источник.Ссылка.Пустая() Или Форма.Модифицированность Тогда
			Возврат; // Запись не удалась, сообщения о причинах выводит платформа.
		КонецЕсли;
		Если Не ПустаяСтрока(ОписаниеКоманды.Обработчик) 
			И СтрНачинаетсяС(ОписаниеКоманды.Обработчик, "ОбменСБанками") Тогда 
			
			Оповестить("ОбновитьСостояниеОбменСБанками");
		Иначе
			
			
			ДокументыУчета = Новый Массив;
			ДокументыУчета.Добавить(Источник.Ссылка);
			
			ПараметрыОповещения = Новый Структура;
			ПараметрыОповещения.Вставить("ДокументыУчета", ДокументыУчета);
			
			Оповестить("ОбновитьСостояниеЭД", ПараметрыОповещения);
			
		КонецЕсли;
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектыОснований = ДополнительныеПараметры.Источник;
	Если ТипЗнч(ОбъектыОснований) <> Тип("Массив") Тогда
		ОбъектыОснований = ОбъектыОснований(ОбъектыОснований);
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("ОбъектыОснований", ОбъектыОснований);
	
	ОписаниеКоманды = ДополнительныеПараметры.ОписаниеКоманды;
	Форма = ДополнительныеПараметры.Форма;
	ОбъектыОснований = ДополнительныеПараметры.ОбъектыОснований;
	
	ОписаниеКоманды = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ОписаниеКоманды);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОбъектыОснований;
		ОписаниеКоманды.Вставить("ПараметрКоманды", ОбъектыОснований);
	Иначе
		Если ОбъектыОснований.Количество() Тогда
			ПараметрКоманды = ОбъектыОснований[0];
		Иначе
			ПараметрКоманды = Неопределено;
		КонецЕсли;
		ОписаниеКоманды.Вставить("ПараметрКоманды", ПараметрКоманды);
	КонецЕсли;
	
	Если ПустаяСтрока(ОписаниеКоманды.Обработчик) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеКоманды.Вставить("Источник", Форма);
	ОписаниеКоманды.Вставить("Уникальность", Ложь);
	
	МассивИмениОбработчика = СтрРазделить(ОписаниеКоманды.Обработчик, ".");
	МодульОбработки = ОбщегоНазначенияКлиент.ОбщийМодуль(МассивИмениОбработчика[0]);
	Обработчик = Новый ОписаниеОповещения(МассивИмениОбработчика[1], МодульОбработки, ОписаниеКоманды);
	ВыполнитьОбработкуОповещения(Обработчик, ПараметрКоманды);
	
КонецПроцедуры

#КонецОбласти
