﻿#Область ПрограммныйИнтерфейс

// Инициировать уведомление о всех имеющихся в МС поставляемых данных (за исключением тех,
// у которых стоит пометка "Запрет уведомления".
//
Процедура ЗапроситьВсеДанные() Экспорт
	
	ОбменСообщениями.ОтправитьСообщение("ПоставляемыеДанные\ЗапросВсехДанных", Неопределено, 
		РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса());
		
КонецПроцедуры

// Получить дескрипторы данных по заданным условиям.
//
// Параметры:
//  ВидДанных - Строка - имя вида поставляемых данных.
//  Фильтр - Массив - элементы должны содержать поля Код (строка) и Значение (строка).
//
// Возвращаемое значение:
//    ОбъектXDTO - типа ArrayOfDescriptor.
//
Функция ДескрипторыПоставляемыхДанныхИзМенеджера(Знач ВидДанных, Знач Фильтр = Неопределено) Экспорт  
	Перем Прокси, Условия, ТипФильтра;
	Прокси = НовыйПроксиНаМенеджереСервиса();
	
	Если Фильтр <> Неопределено Тогда
			
		ТипФильтра = Прокси.ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/SuppliedData",
				"ArrayOfProperty");
		ТипУсловия = Прокси.ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/SuppliedData",
				"Property");
		Условия = Прокси.ФабрикаXDTO.Создать(ТипФильтра);
		Для каждого СтрокаФильтра Из Фильтр Цикл
			Условие = Условия.Property.Добавить(Прокси.ФабрикаXDTO.Создать(ТипУсловия));
			Условие.Code = СтрокаФильтра.Код;
			Условие.Value = СтрокаФильтра.Значение;
		КонецЦикла;
	КонецЕсли;
	
	// Конвертируем в стандартный тип.
	Результат = Прокси.GetData(ВидДанных, Условия);
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	Прокси.ФабрикаXDTO.ЗаписатьXML(Запись, Результат, , , , НазначениеТипаXML.Явное);
	СериализованныйРезультат = Запись.Закрыть();
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(СериализованныйРезультат);
	Результат = ФабрикаXDTO.ПрочитатьXML(Чтение);
	Чтение.Закрыть();
	Возврат Результат;

КонецФункции

// Инициирует обработку данных.
//
// Может использоваться в связке с ДескрипторыПоставляемыхДанныхИзМенеджера для 
// ручной инициации процесса обработки данных. После вызова метода система поведет 
// себя так, как будто она только что получила уведомление о доступности новых данных, 
// с указанным дескриптором - будет вызван ДоступныНовыеДанные, а затем, при необходимости, 
// ОбработатьНовыеДанные для соответствующих обработчиков.
//
// Параметры:
//   Дескриптор - ОбъектXDTO - Descriptor.
//
Процедура ЗагрузитьИОбработатьДанные(Знач Дескриптор) Экспорт
	
	СообщенияПоставляемыхДанныхОбработчикСообщения.ОбработатьНовыйДескриптор(Дескриптор);
	
КонецПроцедуры
	
// Помещает данные в справочник ПоставляемыеДанные.
//
// Данные сохраняются либо в том на диске, либо в поле таблицы ПоставляемыеДанные в 
// зависимости от константы ХранитьФайлыВТомахНаДиске и наличия свободных томов. Данные 
// могут быть позднее извлечены при помощи поиска по реквизитам, либо путем указания 
// уникального идентификатора, который передавался в поле Дескриптор.FileGUID. Если в базе 
// уже есть данные с тем же видом данных и набором ключевых характеристик - новые данные 
// замещают старые. При это используется обновление существующего элемента справочника, а 
// не удаление и создание нового.
//
// Параметры:
//   Дескриптор - ОбъектXDTO - Descriptor или структура с полями.
//	 	"ВидДанных, ДатаДобавления, ИдентификаторФайла, Характеристики",
//    	где Характеристики - массив структур с полями "Код, Значение, Ключевая".
//   ПутьКФайлу - Строка - полное имя извлеченного файла.
//
Процедура СохранитьПоставляемыеДанныеВКэш(Знач Дескриптор, Знач ПутьКФайлу) Экспорт
	
	// Приводим дескриптор к каноническому виду.
	Если ТипЗнч(Дескриптор) = Тип("Структура") Тогда
		НаАнглийском = Новый Структура;
		НаАнглийском.Вставить("DataType", Дескриптор.ВидДанных);
		НаАнглийском.Вставить("CreationDate", Дескриптор.ДатаДобавления);
		НаАнглийском.Вставить("FileGUID", Дескриптор.ИдентификаторФайла);
		НаАнглийском.Вставить("Properties", Новый Структура("Property", Новый Массив));
		
		Если ТипЗнч(Дескриптор.Характеристики) = Тип("Массив") Тогда
			Для каждого Характеристика Из Дескриптор.Характеристики Цикл
				НаАнглийском.Properties.Property.Добавить(Новый Структура("Code, Value, IsKey",
				Характеристика.Код, Характеристика.Значение, Характеристика.Ключевая));
			КонецЦикла; 
		КонецЕсли;
		Дескриптор = НаАнглийском;			
	КонецЕсли;
	
	Фильтр = Новый Массив;
	Для каждого Характеристика Из Дескриптор.Properties.Property Цикл
		Если Характеристика.IsKey Тогда
			Фильтр.Добавить(Новый Структура("Код, Значение", Характеристика.Code, Характеристика.Value));
		КонецЕсли;
	КонецЦикла;
	
	ИсходнаяОбластьДанных = Неопределено;
	Если РаботаВМоделиСервисаПовтИсп.РазделениеВключено() И РаботаВМоделиСервисаПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		ИсходнаяОбластьДанных = РаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		РаботаВМоделиСервиса.УстановитьРазделениеСеанса(Ложь);
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
	
		Запрос = ЗапросДанныхПоИменам(Дескриптор.DataType, Фильтр);
		Результат = Запрос.Выполнить();
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ПоставляемыеДанные");
		ЭлементБлокировки.ИсточникДанных = Результат;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "ПоставляемыеДанные");
		Блокировка.Заблокировать();
		
		Выборка = Результат.Выбрать();
		
		Данные = Неопределено;
		ПутьКСтаромуФайлу = Неопределено;
		
		Пока Выборка.Следующий() Цикл
			Если Данные = Неопределено Тогда
				Данные = Выборка.ПоставляемыеДанные.ПолучитьОбъект();
				Если Данные.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске Тогда
					ПутьКСтаромуФайлу = РаботаСФайламиСлужебный.ПолныйПутьТома(Данные.Том) + Данные.ПутьКФайлу;
				КонецЕсли;
			Иначе
				УдалитьПоставляемыеДанныеИзКэша(Выборка.ПоставляемыеДанные);
			КонецЕсли;
		КонецЦикла;		
		
		Если Данные = Неопределено Тогда
			Данные = Справочники.ПоставляемыеДанные.СоздатьЭлемент();
		КонецЕсли;
			
		Данные.ВидДанных =  Дескриптор.DataType;
		Данные.ДатаДобавления = Дескриптор.CreationDate;
		Данные.ИдентификаторФайла = Дескриптор.FileGUID;
		Данные.ХарактеристикиДанных.Очистить();
		Для каждого Property Из Дескриптор.Properties.Property Цикл
			Характеристика = Данные.ХарактеристикиДанных.Добавить();
			Характеристика.Характеристика = Property.Code;
			Характеристика.Значение = Property.Value;
		КонецЦикла; 
		Данные.ТипХраненияФайла = РаботаСФайламиСлужебный.ТипХраненияФайлов();

		Если Данные.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
			Данные.ХранимыйФайл = Новый ХранилищеЗначения(Новый ДвоичныеДанные(ПутьКФайлу));
			Данные.Том = Справочники.ТомаХраненияФайлов.ПустаяСсылка();
			Данные.ПутьКФайлу = "";
		Иначе
			// Добавление в один из томов (где есть свободное место).
			СведенияОФайле = РаботаСФайламиСлужебный.ДобавитьФайлВТом(ПутьКФайлу, Данные.ДатаДобавления, Строка(Данные.ИдентификаторФайла), "");
			Данные.ХранимыйФайл = Неопределено;
			Данные.Том = СведенияОФайле.Том;
			Данные.ПутьКФайлу = СведенияОФайле.ПутьКФайлу;
		КонецЕсли;
		
		Данные.Записать();
		Если ПутьКСтаромуФайлу <> Неопределено Тогда
			
			ФайлВременный = Новый Файл(ПутьКСтаромуФайлу);
			Если ФайлВременный.Существует() Тогда
				
				Попытка
					ФайлВременный.УстановитьТолькоЧтение(Ложь);
					УдалитьФайлы(ПутьКСтаромуФайлу);
				Исключение
					ЗаписьЖурналаРегистрации(
						НСтр("ru = 'Поставляемые данные.Удаление файлов в томе'",
						     ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
						УровеньЖурналаРегистрации.Ошибка,
						,
						,
						ИнформацияОбОшибке());
				КонецПопытки;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ИсходнаяОбластьДанных <> Неопределено Тогда
			
			РаботаВМоделиСервиса.УстановитьРазделениеСеанса(Истина, ИсходнаяОбластьДанных);
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		Если ИсходнаяОбластьДанных <> Неопределено Тогда
			
			РаботаВМоделиСервиса.УстановитьРазделениеСеанса(Истина, ИсходнаяОбластьДанных);
			
		КонецЕсли;
		
		ВызватьИсключение;
		
	КонецПопытки;
		
КонецПроцедуры

// Удаляет файл из кэша.
//
// Параметры:
//  СсылкаИлиИдентификатор - СправочникСсылка.ПоставляемыеДанные - ссылка на поставляемые данные,
//                         - УникальныйИдентификатор - уникальный идентификатор.
//
Процедура УдалитьПоставляемыеДанныеИзКэша(Знач СсылкаИлиИдентификатор) Экспорт
	Перем Данные, ПолныйПуть;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(СсылкаИлиИдентификатор) = Тип("УникальныйИдентификатор") Тогда
		СсылкаИлиИдентификатор = Справочники.ПоставляемыеДанные.НайтиПоРеквизиту("ИдентификаторФайла", СсылкаИлиИдентификатор);
		Если СсылкаИлиИдентификатор.Пустая() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Данные = СсылкаИлиИдентификатор.ПолучитьОбъект();
	Если Данные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если Данные.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске Тогда
		ПолныйПуть = РаботаСФайламиСлужебный.ПолныйПутьТома(Данные.Том) + Данные.ПутьКФайлу;
		УдалитьФайлы(ПолныйПуть);
	КонецЕсли;
	
	Удаление = Новый УдалениеОбъекта(СсылкаИлиИдентификатор);
	Удаление.ОбменДанными.Загрузка = Истина;
	Удаление.Записать();
	
КонецПроцедуры

// Получает дескриптор данных из кэша.
//
// Параметры:
//  СсылкаИлиИдентификатор - СправочникСсылка.ПоставляемыеДанные - ссылка на поставляемые данные,
//                         - УникальныйИдентификатор - уникальный идентификатор,
//  ВВидеXDTO - Булево - в каком виде возвращать значения.
//
// Возвращаемое значение:
//    ОбъектXDTO - типа ArrayOfDescriptor.
//
Функция ДескрипторПоставляемыхДанныхИзКэша(Знач СсылкаИлиИдентификатор, Знач ВВидеXDTO = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	
	Если ТипЗнч(СсылкаИлиИдентификатор) = Тип("УникальныйИдентификатор") Тогда
		Суффикс = "СправочникПоставляемыеДанные.ИдентификаторФайла = &ИдентификаторФайла";
		Запрос.УстановитьПараметр("ИдентификаторФайла", СсылкаИлиИдентификатор);
	Иначе
		Суффикс = "СправочникПоставляемыеДанные.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", СсылкаИлиИдентификатор);
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ
    |	СправочникПоставляемыеДанные.ИдентификаторФайла,
    |	СправочникПоставляемыеДанные.ДатаДобавления,
    |	СправочникПоставляемыеДанные.ВидДанных,
    |	СправочникПоставляемыеДанные.ХарактеристикиДанных.(
    |		Значение,
    |		Характеристика)
	|ИЗ
	|	Справочник.ПоставляемыеДанные КАК СправочникПоставляемыеДанные
	|	ГДЕ " + Суффикс;
	 
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат ?(ВВидеXDTO, ПолучитьXDTOДескриптор(Выборка), ПолучитьДескриптор(Выборка));
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает двоичные данные присоединенного файла.
//
// Параметры:
//  СсылкаИлиИдентификатор - СправочникСсылка.ПоставляемыеДанные - ссылка на поставляемые данные,
//                         - УникальныйИдентификатор - уникальный идентификатор.
//
// Возвращаемое значение:
//  ДвоичныеДанные - двоичные данные поставляемых данных.
//
Функция ПоставляемыеДанныеИзКэша(Знач СсылкаИлиИдентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(СсылкаИлиИдентификатор) = Тип("УникальныйИдентификатор") Тогда
		СсылкаИлиИдентификатор = Справочники.ПоставляемыеДанные.НайтиПоРеквизиту("ИдентификаторФайла", СсылкаИлиИдентификатор);
		Если СсылкаИлиИдентификатор.Пустая() Тогда
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	ФайлОбъект = СсылкаИлиИдентификатор.ПолучитьОбъект();
	Если ФайлОбъект = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ФайлОбъект.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
		Возврат ФайлОбъект.ХранимыйФайл.Получить();
	Иначе
		ПолныйПуть = РаботаСФайламиСлужебный.ПолныйПутьТома(ФайлОбъект.Том) + ФайлОбъект.ПутьКФайлу;
		
		Попытка
			Возврат Новый ДвоичныеДанные(ПолныйПуть)
		Исключение
			// Запись в журнал регистрации.
			СообщениеОбОшибке = ТекстОшибкиПриПолученииФайла(ИнформацияОбОшибке(), СсылкаИлиИдентификатор);
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Поставляемые данные.Получение файла из тома'", 
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.ПоставляемыеДанные,
				СсылкаИлиИдентификатор,
				СообщениеОбОшибке);
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка открытия файла: файл не найден на сервере.
				           |Обратитесь к администратору.
				           |
				           |Файл: ""%1.%2"".'"),
				ФайлОбъект.Наименование,
				ФайлОбъект.Расширение);
		КонецПопытки;
	КонецЕсли;
	
КонецФункции

// Проверяет наличие данных с указанными ключевыми характеристиками в кэше.
//
// Параметры:
//   Дескриптор - ОбъектXDTO - Descriptor.
//
// Возвращаемое значение:
//  Булево - наличие дескриптора в кэше.
//
Функция ЕстьВКеше(Знач Дескриптор) Экспорт
	
	Фильтр = Новый Массив;
	Для каждого Характеристика Из Дескриптор.Properties.Property Цикл
		Если Характеристика.IsKey Тогда
			Фильтр.Добавить(Новый Структура("Код, Значение", Характеристика.Code, Характеристика.Value));
		КонецЕсли;
	КонецЦикла;
	
	Запрос = ЗапросДанныхПоИменам(Дескриптор.DataType, Фильтр);
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

// Возвращает массив ссылок на данные, удовлетворяющие заданным условиям.
//
// Параметры:
//  ВидДанных - Строка - имя вида поставляемых данных.
//  Фильтр - Массив - элементы должны содержать поля Код (строка) и Значение (строка).
//
// Возвращаемое значение:
//    Массив - массив ссылок на данные.
//
Функция СсылкиПоставляемыхДанныхИзКэша(Знач ВидДанных, Знач Фильтр = Неопределено) Экспорт
	
	Запрос = ЗапросДанныхПоИменам(ВидДанных, Фильтр);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ПоставляемыеДанные");
	
КонецФункции

// Получить данные по заданным условиям.
//
// Параметры:
//  ВидДанных - Строка - имя вида поставляемых данных.
//  Фильтр - Массив - элементы должны содержать поля Код (строка) и Значение (строка).
//  ВВидеXDTO - Булево - в каком виде возвращать значения.
//
// Возвращаемое значение:
//    ОбъектXDTO - типа ArrayOfDescriptor или
//    Массив структур с полями "ВидДанных, ДатаДобавления, ИдентификаторФайла, Характеристики",
//    где Характеристики - массив структур с полями "Код, Значение, Ключевая".
//	  Для получения самого файла необходимо вызвать ПолучитьПоставляемыеДанныеИзКэша.
//
//
Функция ДескрипторыПоставляемыхДанныхИзКэша(Знач ВидДанных, Знач Фильтр = Неопределено, Знач ВВидеXDTO = Ложь) Экспорт
	Перем Запрос, РезультатЗапроса, Выборка, Дескрипторы, Результат;
	
	Запрос = ЗапросДанныхПоИменам(ВидДанных, Фильтр);
		
	Запрос.Текст = "ВЫБРАТЬ
    |	СправочникПоставляемыеДанные.ИдентификаторФайла,
    |	СправочникПоставляемыеДанные.ДатаДобавления,
    |	СправочникПоставляемыеДанные.ВидДанных,
    |	СправочникПоставляемыеДанные.ХарактеристикиДанных.(
    |		Значение,
    |		Характеристика)
	|ИЗ
	|	Справочник.ПоставляемыеДанные КАК СправочникПоставляемыеДанные
	|	ГДЕ СправочникПоставляемыеДанные.Ссылка В (" + Запрос.Текст + ")";
	 
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если ВВидеXDTO Тогда
		Результат = СоздатьОбъект(ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/SuppliedData",
				"ArrayOfDescriptor"));
		Дескрипторы = Результат.Descriptor;
	Иначе
		Результат = Новый Массив();
		Дескрипторы = Результат;
	КонецЕсли;

	Пока Выборка.Следующий()  Цикл
		Сообщение = ?(ВВидеXDTO, ПолучитьXDTOДескриптор(Выборка), ПолучитьДескриптор(Выборка));
		Дескрипторы.Добавить(Сообщение);
	КонецЦикла;		
	
	Возврат Результат;
	
КонецФункции	

// Возвращает пользовательское представление дескриптора поставляемых данных.
// Может быть использовано при выводе сообщений в журнал регистрации.
//
// Параметры:
//  Дескриптор - ОбъектXDTO - типа Descriptor или  структура с полями.
//	 	"ВидДанных, ДатаДобавления, ИдентификаторФайла, Характеристики",
//    	где Характеристики - массив структур с полями "Код, Значение".
//
// Возвращаемое значение:
//  Строка - пользовательское представление дескриптора.
//
Функция ПолучитьОписаниеДанных(Знач Дескриптор) Экспорт
	Перем Описание, Характеристика;
	
	Если Дескриптор = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	Если ТипЗнч(Дескриптор) = Тип("ОбъектXDTO") Тогда
		Описание = Дескриптор.DataType;
		Для каждого Характеристика Из Дескриптор.Properties.Property Цикл
			Описание = Описание
				+ ", " + Характеристика.Code + ": " + Характеристика.Value;
		КонецЦикла; 
		
		Описание = Описание + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = ', добавлен: %1 (%2), рекомендовано загрузить: %3 (%2)'"), 
			МестноеВремя(Дескриптор.CreationDate, ЧасовойПоясСеанса()),
			ПредставлениеЧасовогоПояса(ЧасовойПоясСеанса()), 
			МестноеВремя(Дескриптор.RecommendedUpdateDate));
	Иначе
		Описание = Дескриптор.ВидДанных;
		Для каждого Характеристика Из Дескриптор.Характеристики Цикл
			Описание = Описание
				+ ", " + Характеристика.Код + ": " + Характеристика.Значение;
		КонецЦикла; 
		
		Описание = Описание + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = ', добавлен: %1 (%2)'"), 
			МестноеВремя(Дескриптор.ДатаДобавления, ЧасовойПоясСеанса()),
			ПредставлениеЧасовогоПояса(ЧасовойПоясСеанса()));
	КонецЕсли;
		
	Возврат Описание;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////////
// Обновление информации в областях данных.

// Возвращает список областей данных, в которые еще не были скопированы поставляемые данные.
//
// В случае первого вызова функции возвращается полный набор доступных областей.
// При последующем вызове, при восстановлении после сбоя, будут возвращены только
// необработанные области. После копирования данных в область следует вызвать ОбластьОбработана.
//
// Параметры:
//  ИдентификаторФайла - УникальныйИдентификатор - идентификатор файла поставляемых данных,
//  КодОбработчика - Строка - код обработчика,
//  ВключаяНеразделенную - Булево - если Истина, ко всем имеющимся областям добавится область с кодом -1.
// 
// Возвращаемое значение:
//  Массив - области требующие обработки.
//
Функция ОбластиТребующиеОбработки(Знач ИдентификаторФайла, Знач КодОбработчика, Знач ВключаяНеразделенную = Ложь) Экспорт
	
	НаборЗаписей = РегистрыСведений.ОбластиТребующиеОбработкиПоставляемыхДанных.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторФайла.Установить(ИдентификаторФайла);
	НаборЗаписей.Отбор.КодОбработчика.Установить(КодОбработчика);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() = 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	&ИдентификаторФайла КАК ИдентификаторФайла,
		               |	&КодОбработчика КАК КодОбработчика,
		               |	ОбластиДанных.ОбластьДанныхВспомогательныеДанные КАК ОбластьДанных
		               |ИЗ
		               |	РегистрСведений.ОбластиДанных КАК ОбластиДанных
		               |ГДЕ
		               |	ОбластиДанных.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОбластейДанных.Используется)";
		Запрос.УстановитьПараметр("ИдентификаторФайла", ИдентификаторФайла);
		Запрос.УстановитьПараметр("КодОбработчика", КодОбработчика);
		НаборЗаписей.Загрузить(Запрос.Выполнить().Выгрузить());
		
		Если ВключаяНеразделенную Тогда
			ОбщиеКурсы = НаборЗаписей.Добавить();
			ОбщиеКурсы.ИдентификаторФайла = ИдентификаторФайла;
			ОбщиеКурсы.КодОбработчика = КодОбработчика;
			ОбщиеКурсы.ОбластьДанных = -1;
		КонецЕсли;
		
		НаборЗаписей.Записать();
	КонецЕсли;
	Возврат НаборЗаписей.ВыгрузитьКолонку("ОбластьДанных");
КонецФункции	

// Удаляет область из списка необработанных. Выключает разделение сеанса (если оно было включено),
// поскольку при включенном разделении запись в неразделенный регистр запрещена.
//
// Параметры:
//  ИдентификаторФайла - УникальныйИдентификатор - файла поставляемых данных,
//  КодОбработчика - Строка - код обработчика,
//  ОбластьДанных - Число - идентификатор обработанной области.
// 
Процедура ОбластьОбработана(Знач ИдентификаторФайла, Знач КодОбработчика, Знач ОбластьДанных) Экспорт
	
	Если РаботаВМоделиСервисаПовтИсп.РазделениеВключено() И РаботаВМоделиСервисаПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		РаботаВМоделиСервиса.УстановитьРазделениеСеанса(Ложь);
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ОбластиТребующиеОбработкиПоставляемыхДанных.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторФайла.Установить(ИдентификаторФайла);
	Если ОбластьДанных <> Неопределено Тогда
		НаборЗаписей.Отбор.ОбластьДанных.Установить(ОбластьДанных);
	КонецЕсли;
	НаборЗаписей.Отбор.КодОбработчика.Установить(КодОбработчика);
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков.
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить("СообщенияПоставляемыхДанныхОбработчикСообщения.ЗагрузитьДанные");
	
КонецПроцедуры

// См. ОбменСообщениямиПереопределяемый.ПолучитьОбработчикиКаналовСообщений.
Процедура ПриОпределенииОбработчиковКаналовСообщений(Обработчики) Экспорт
	
	СообщенияПоставляемыхДанныхОбработчикСообщения.ПолучитьОбработчикиКаналовСообщений(Обработчики);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйПроксиНаМенеджереСервиса()
	
	URL = РаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса();
	ИмяПользователя = РаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса();
	ПарольПользователя = РаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса();

	АдресСервиса = URL + "/ws/SuppliedData?wsdl";
	
	ПараметрыПодключения = ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
	ПараметрыПодключения.АдресWSDL = АдресСервиса;
	ПараметрыПодключения.URIПространстваИмен = "http://www.1c.ru/SaaS/1.0/WS";
	ПараметрыПодключения.ИмяСервиса = "SuppliedData";
	ПараметрыПодключения.ИмяПользователя = ИмяПользователя; 
	ПараметрыПодключения.Пароль = ПарольПользователя;
	
	Возврат ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
	
КонецФункции

// Получить запрос, возвращающий ссылки на данные с указанными характеристиками.
//
// Параметры:
//  ВидДанных      - строка.
//  Характеристики - коллекция, содержащая структуры Код(строка).
//                   И Значение(строка).
//
// Возвращаемое значение:
//   Запрос
Функция ЗапросДанныхПоИменам(Знач ВидДанных, Знач Характеристики)
	Если Характеристики = Неопределено Или Характеристики.Количество() = 0 Тогда
		Возврат ЗапросПоИмениВидаДанных(ВидДанных);
	Иначе
		Возврат ЗапросПоИменамХарактеристик(ВидДанных, Характеристики);
	КонецЕсли;
КонецФункции

Функция ЗапросПоИмениВидаДанных(Знач ВидДанных)
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	ПоставляемыеДанные.Ссылка КАК ПоставляемыеДанные
	|ИЗ
	|	Справочник.ПоставляемыеДанные КАК ПоставляемыеДанные
	|ГДЕ
	|	ПоставляемыеДанные.ВидДанных = &ВидДанных";
	Запрос.УстановитьПараметр("ВидДанных", ВидДанных);
	Возврат Запрос;
	
КонецФункции

Функция ЗапросПоИменамХарактеристик(Знач ВидДанных, Знач Характеристики)
// ВЫБРАТЬ Ссылка
// ИЗ Характеристики
// ГДЕ (ИмяХарактеристики = '' И ЗначениеХарактеристики = '') ИЛИ ..(N)
// СГРУППИРОВАТЬ ПО ДанныеИд
// ИМЕЮЩИЕ Количество(*) = N.
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоставляемыеДанныеХарактеристикиДанных.Ссылка КАК ПоставляемыеДанные
	|ИЗ
	|	Справочник.ПоставляемыеДанные.ХарактеристикиДанных КАК ПоставляемыеДанныеХарактеристикиДанных
	|ГДЕ 
	|	ПоставляемыеДанныеХарактеристикиДанных.Ссылка.ВидДанных = &ВидДанных И (";
	Счетчик = 0;
	Для Каждого Характеристика Из Характеристики Цикл
		Если Счетчик > 0 Тогда
			Запрос.Текст = Запрос.Текст + " ИЛИ ";
		КонецЕсли; 
		
		Запрос.Текст = Запрос.Текст + "(
		| ВЫРАЗИТЬ(ПоставляемыеДанныеХарактеристикиДанных.Значение КАК Строка(150)) = &Значение" + Счетчик + "
		| И ПоставляемыеДанныеХарактеристикиДанных.Характеристика = &Код" + Счетчик + ")";
		Запрос.УстановитьПараметр("Значение" + Счетчик, Характеристика.Значение);
		Запрос.УстановитьПараметр("Код" + Счетчик, Характеристика.Код);
		Счетчик = Счетчик + 1;
	КонецЦикла;
	Запрос.Текст = Запрос.Текст + ")
	|СГРУППИРОВАТЬ ПО
	|	ПоставляемыеДанныеХарактеристикиДанных.Ссылка
	|ИМЕЮЩИЕ
	|Количество(*) = &Количество";
	Запрос.УстановитьПараметр("Количество", Счетчик);
	Запрос.УстановитьПараметр("ВидДанных", ВидДанных);
	Возврат Запрос;
	
КонецФункции

// Преобразование результатов выборки в XDTO объект.
//
// Параметры:
//  Выборка      - ВыборкаИзРезультатаЗапроса. Выборка запроса, содержащего информацию об
//                 обновлении данных.
//
Функция ПолучитьXDTOДескриптор(Выборка)
	Дескриптор = СоздатьОбъект(ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/SuppliedData",
				"Descriptor"));
	Дескриптор.DataType = Выборка.ВидДанных;
	Дескриптор.CreationDate = Выборка.ДатаДобавления;
	Дескриптор.FileGUID = Выборка.ИдентификаторФайла;
	Дескриптор.Properties = СоздатьОбъект(ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/SuppliedData",
				"ArrayOfProperty"));
	ВыборкаХарактеристик = Выборка.ХарактеристикиДанных.Выбрать();
	Пока ВыборкаХарактеристик.Следующий() Цикл
		Характеристика = СоздатьОбъект(ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/SuppliedData",
				"Property"));
		Характеристика.Code = ВыборкаХарактеристик.Характеристика;
		Характеристика.Value = ВыборкаХарактеристик.Значение;
		Характеристика.IsKey = Истина;
		Дескриптор.Properties.Property.Добавить(Характеристика);
	КонецЦикла; 
	Возврат Дескриптор;
	
КонецФункции

Функция ПолучитьДескриптор(Знач Выборка)
	Перем Дескриптор, ВыборкаХарактеристик, Характеристика;
	
	Дескриптор = Новый Структура("ВидДанных, ДатаДобавления, ИдентификаторФайла, Характеристики");
	Дескриптор.ВидДанных = Выборка.ВидДанных;
	Дескриптор.ДатаДобавления = Выборка.ДатаДобавления;
	Дескриптор.ИдентификаторФайла = Выборка.ИдентификаторФайла;
	Дескриптор.Характеристики = Новый Массив();
	
	ВыборкаХарактеристик = Выборка.ХарактеристикиДанных.Выбрать();
	Пока ВыборкаХарактеристик.Следующий() Цикл
		Характеристика = Новый Структура("Код, Значение, Ключевая");
		Характеристика.Код = ВыборкаХарактеристик.Характеристика;
		Характеристика.Значение = ВыборкаХарактеристик.Значение;
		Характеристика.Ключевая = Истина;
		Дескриптор.Характеристики.Добавить(Характеристика);
	КонецЦикла; 
	
	Возврат Дескриптор;
	
КонецФункции

Функция СоздатьОбъект(Знач ТипСообщения)
	
	Возврат ФабрикаXDTO.Создать(ТипСообщения);
	
КонецФункции

Функция ТекстОшибкиПриПолученииФайла(Знач ИнформацияОбОшибке, Знач Файл)
	
	СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	
	Если Файл <> Неопределено Тогда
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
			           |
			           |Ссылка на файл: ""%2"".'"),
			СообщениеОбОшибке,
			ПолучитьНавигационнуюСсылку(Файл));
	КонецЕсли;
	
	Возврат СообщениеОбОшибке;
	
КонецФункции

// Сравнивает, удовлетворяет ли набор характеристик, полученный из дескриптора, условиям фильтра.
//
// Параметры:
//  Фильтр - Коллекция объектов с полями Код и Значение.
//  Характеристики - Коллекция объектов с полями Код и Значение.
//
// Возвращаемое значение
//   Булево
//
Функция ХарактеристикиСовпадают(Знач Фильтр, Знач Характеристики) Экспорт

	Для Каждого СтрокаФильтр Из Фильтр Цикл
		СтрокаНайдена = Ложь;
		Для Каждого Характеристика Из Характеристики Цикл 
			Если Характеристика.Код = СтрокаФильтр.Код Тогда
				Если Характеристика.Значение = СтрокаФильтр.Значение Тогда
					СтрокаНайдена = Истина;
				Иначе 
					Возврат Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Если Не СтрокаНайдена Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
		
	Возврат Истина;
	
КонецФункции	

#КонецОбласти
