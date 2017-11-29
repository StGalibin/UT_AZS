﻿#Область ПрограммныйИнтерфейс
// Функция возвращает JSON-текст Post запроса в формате XDTO-пакета Evotor.
//		Параметры:
//			- СтруктураЗаписиJSON - <Cтруктура>
//			- структура данных, преобразуемая в JSON, для передачи в облако Эвотор
//			- ВидЗапроса - <Строка>
//			- вид запроса к облаку Эвотор
//			// Возвращаемое значение:
//			<Строка> - Результат работы функции.
//
Функция ПолучитьТекстJSONЗапроса(СтруктураЗаписиJSON, ВидЗапроса) Экспорт
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	
	Если ВидЗапроса = "ВыгрузитьТовары" Тогда
		
		МассивТоваров = Новый Массив;
		
		Если Не СтруктураЗаписиJSON.Товары.Количество() = 0 ИЛИ Не СтруктураЗаписиJSON.ГруппыТоваров.Количество() = 0 Тогда
			
			СтруктураТовара = Новый Структура;
			СтруктураТовара.Вставить("uuid");
			СтруктураТовара.Вставить("code");
			СтруктураТовара.Вставить("barCodes",  Новый Массив);
			СтруктураТовара.Вставить("alcoCodes", Новый Массив);
			СтруктураТовара.Вставить("name");
			СтруктураТовара.Вставить("price");
			СтруктураТовара.Вставить("quantity");
			СтруктураТовара.Вставить("costPrice");
			СтруктураТовара.Вставить("measureName");
			СтруктураТовара.Вставить("tax");
			СтруктураТовара.Вставить("allowToSell");
			СтруктураТовара.Вставить("description");
			СтруктураТовара.Вставить("articleNumber");
			СтруктураТовара.Вставить("parentUuid");
			СтруктураТовара.Вставить("group");
			СтруктураТовара.Вставить("type");
			СтруктураТовара.Вставить("alcoholByVolume");
			СтруктураТовара.Вставить("alcoholProductKindCode");
			СтруктураТовара.Вставить("tareVolume");
			
			СоответствиеТоваровГрупп = Новый Соответствие;
			
			Для Каждого Группа Из СтруктураЗаписиJSON.ГруппыТоваров Цикл
				
				СтруктураТовара = ПолучитьТовар();
				СтруктураТовара.uuid                   = Группа.УникальныйИдентификатор;
				СтруктураТовара.code                   = Группа.Код;
				СтруктураТовара.name                   = Группа.Наименование;
				СтруктураТовара.price                  = 0;
				СтруктураТовара.quantity               = 0;
				СтруктураТовара.costPrice              = 0;
				СтруктураТовара.measureName            = "";
				СтруктураТовара.tax                    = "NO_VAT";
				СтруктураТовара.allowToSell            = Истина;
				СтруктураТовара.description            = "";
				СтруктураТовара.articleNumber          = "";
				СтруктураТовара.group                  = Истина;
				СтруктураТовара.type                   = "NORMAL";
				СтруктураТовара.alcoholByVolume        = 0;
				СтруктураТовара.alcoholProductKindCode = 0;
				СтруктураТовара.tareVolume             = 0;
				СоответствиеТоваровГрупп.Вставить(Группа.Код, Группа.УникальныйИдентификатор);
				Если Группа.КодГруппы <> 0 Тогда
					СтруктураТовара.parentUuid = СоответствиеТоваровГрупп.Получить(Группа.КодГруппы);
				Иначе
					СтруктураТовара.parentUuid = Неопределено;
				КонецЕсли;
				
				МассивТоваров.Добавить(СтруктураТовара);
				
			КонецЦикла;
			
			Для Каждого Товар Из СтруктураЗаписиJSON.Товары Цикл
				Если Товар.ИмеетХарактеристики Тогда
					Для Каждого Характеристика Из Товар.Характеристики Цикл
						Если Характеристика.ИмеетУпаковки Тогда
							Для Каждого Упаковка Из Характеристика.Упаковки Цикл
								СтруктураТовара = ПолучитьТовар();
								СтруктураТовара.name      = Товар.Наименование + Характеристика.Наименование + Упаковка.Наименование;
								СтруктураТовара.price     = Упаковка.Цена;
								СтруктураТовара.quantity  = Упаковка.Остаток;
								СтруктураТовара.costPrice = Упаковка.Цена;
								Если Не ПустаяСтрока(Упаковка.УникальныйИдентификатор) Тогда
									СтруктураТовара.uuid      = Строка(Упаковка.УникальныйИдентификатор);
								Иначе
									СтруктураТовара.uuid      = Строка(Характеристика.УникальныйИдентификатор);
								КонецЕсли;
								СтруктураТовара.code      = Упаковка.Код;
								Если Товар.КодГруппы <> 0 Тогда
									СтруктураТовара.parentUuid = СоответствиеТоваровГрупп.Получить(Товар.КодГруппы);
								Иначе
									СтруктураТовара.parentUuid = Неопределено;
								КонецЕсли;
								ЗаписатьШтрихкодыТовара(Упаковка.Штрихкод, СтруктураТовара);
								ЗаполнитьТовар(СтруктураТовара, Товар);
								МассивТоваров.Добавить(СтруктураТовара);
							КонецЦикла;
						Иначе
							СтруктураТовара = ПолучитьТовар();
							СтруктураТовара.name      = Товар.Наименование + Характеристика.Наименование;
							СтруктураТовара.price     = Характеристика.Цена;
							СтруктураТовара.quantity  = Характеристика.Остаток;
							СтруктураТовара.costPrice = Характеристика.Цена;
							Если Не ПустаяСтрока(Характеристика.УникальныйИдентификатор) Тогда
								СтруктураТовара.uuid      = Строка(Характеристика.УникальныйИдентификатор);
							Иначе
								СтруктураТовара.uuid      = Строка(Товар.УникальныйИдентификатор);
							КонецЕсли;
							СтруктураТовара.code      = Характеристика.Код;
							Если Товар.КодГруппы <> 0 Тогда
								СтруктураТовара.parentUuid = СоответствиеТоваровГрупп.Получить(Товар.КодГруппы);
							Иначе
								СтруктураТовара.parentUuid = Неопределено;
							КонецЕсли;
							ЗаписатьШтрихкодыТовара(Характеристика.Штрихкод, СтруктураТовара);
							ЗаполнитьТовар(СтруктураТовара, Товар);
							МассивТоваров.Добавить(СтруктураТовара);
						КонецЕсли;
					КонецЦикла;
				ИначеЕсли Товар.ИмеетУпаковки Тогда
					Для Каждого Упаковка Из Товар.Упаковки Цикл
						СтруктураТовара = ПолучитьТовар();
						СтруктураТовара.name      = Товар.Наименование + Упаковка.Наименование;
						СтруктураТовара.price     = Упаковка.Цена;
						СтруктураТовара.quantity  = Упаковка.Остаток;
						СтруктураТовара.costPrice = Упаковка.Цена;
						Если Не ПустаяСтрока(Упаковка.УникальныйИдентификатор) Тогда
							СтруктураТовара.uuid      = Строка(Упаковка.УникальныйИдентификатор);
						Иначе
							СтруктураТовара.uuid      = Строка(Товар.УникальныйИдентификатор);
						КонецЕсли;
						СтруктураТовара.code      = Упаковка.Код;
						Если Товар.КодГруппы <> 0 Тогда
							СтруктураТовара.parentUuid = СоответствиеТоваровГрупп.Получить(Товар.КодГруппы);
						Иначе
							СтруктураТовара.parentUuid = Неопределено;
						КонецЕсли;
						ЗаписатьШтрихкодыТовара(Упаковка.Штрихкод, СтруктураТовара);
						ЗаполнитьТовар(СтруктураТовара, Товар);
						МассивТоваров.Добавить(СтруктураТовара);
					КонецЦикла;
				Иначе
					СтруктураТовара = ПолучитьТовар();
					СтруктураТовара.name      = Товар.Наименование;
					СтруктураТовара.price     = Товар.Цена;
					СтруктураТовара.quantity  = Товар.Остаток;
					СтруктураТовара.costPrice = Товар.Цена;
					СтруктураТовара.uuid      = Строка(Товар.УникальныйИдентификатор);
					СтруктураТовара.code      = Товар.Код;
					Если Товар.КодГруппы <> 0 Тогда
						СтруктураТовара.parentUuid = СоответствиеТоваровГрупп.Получить(Товар.КодГруппы);
					Иначе
						СтруктураТовара.parentUuid = Неопределено;
					КонецЕсли;
					ЗаписатьШтрихкодыТовара(Товар.Штрихкод, СтруктураТовара);
					ЗаполнитьТовар(СтруктураТовара, Товар);
					МассивТоваров.Добавить(СтруктураТовара);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		ЗаписатьJSON(ЗаписьJSON, МассивТоваров);
		
	ИначеЕсли ВидЗапроса = "УдалитьТовары" Тогда
		МассивТоваров = Новый Массив;
		Если ЗначениеЗаполнено(СтруктураЗаписиJSON) Тогда
			Для Каждого Товар Из СтруктураЗаписиJSON Цикл
				МассивТоваров.Добавить(Товар.УникальныйИдентификатор);
			КонецЦикла;
		КонецЕсли;
		ЗаписатьJSON(ЗаписьJSON, МассивТоваров);
	КонецЕсли;
	
	ТекстСообщения = ЗаписьJSON.Закрыть();
	
	Возврат ТекстСообщения;
	
КонецФункции
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Процедура ЗаполнитьТовар(СтруктураТовара, Товар)
	
	Если Товар.Алкоголь <> Неопределено Тогда
		Если Товар.Алкоголь Тогда
			
			СтруктураТовара.alcoholByVolume        = Товар.Крепость;
			СтруктураТовара.alcoholProductKindCode = Товар.КодВидаАлкогольнойПродукции;
			СтруктураТовара.tareVolume             = Товар.ЕмкостьТары;
			Если Товар.Маркируемый = Истина Тогда
				СтруктураТовара.type               = "ALCOHOL_MARKED";
			Иначе
				СтруктураТовара.type               = "ALCOHOL_NOT_MARKED";
			КонецЕсли;
			
		Иначе
			
			СтруктураТовара.alcoholByVolume        = 0;
			СтруктураТовара.alcoholProductKindCode = 0;
			СтруктураТовара.tareVolume             = 0;
			СтруктураТовара.type                   = "NORMAL";
			
		КонецЕсли;
		
	Иначе
		
		СтруктураТовара.alcoholByVolume        = 0;
		СтруктураТовара.alcoholProductKindCode = 0;
		СтруктураТовара.tareVolume             = 0;
		СтруктураТовара.type                   = "NORMAL";
		
	КонецЕсли;
	
	СтруктураТовара.allowToSell                = Истина;
	СтруктураТовара.articleNumber              = Товар.Артикул;
	СтруктураТовара.description                = "";
	СтруктураТовара.group                      = Ложь;
	СтруктураТовара.measureName                = Товар.ЕдиницаИзмерения;
	Если Строка(Товар.СтавкаНДС) = "18" Тогда
		СтруктураТовара.tax                    = "VAT_18";
	ИначеЕсли Строка(Товар.СтавкаНДС) = "10" Тогда
		СтруктураТовара.tax                    = "VAT_10";
	ИначеЕсли Строка(Товар.СтавкаНДС) = "0" Тогда
		СтруктураТовара.tax                    = "VAT_0";
	ИначеЕсли Строка(Товар.СтавкаНДС) = "110" Тогда
		СтруктураТовара.tax                    = "VAT_10_110";
	ИначеЕсли Строка(Товар.СтавкаНДС) = "118" Тогда
		СтруктураТовара.tax                    = "VAT_18_118";
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьШтрихкодыТовара(Штрихкод, СтруктураТовара)
	
	СтрокаШтрихкод = СокрЛП(Штрихкод);
	
	СписокРазделителей = Новый Массив;
	
	СписокРазделителей.Добавить(",");
	СписокРазделителей.Добавить(";");
	СписокРазделителей.Добавить(".");
	СписокРазделителей.Добавить(" ");
	
	Для Каждого Разделитель Из СписокРазделителей Цикл
		
		СтрокаШтрихкод = СтрЗаменить(СокрЛП(СтрокаШтрихкод), Разделитель, ",");
		
	КонецЦикла;
	
	Пока СтрДлина(СтрокаШтрихкод)>0 Цикл
		
		НомерСимвола = СтрНайти(СтрокаШтрихкод, ",");
		Если НомерСимвола > 0 Тогда
			Штрихкод = Лев(СтрокаШтрихкод, НомерСимвола - 1);
		Иначе
			Штрихкод = СтрокаШтрихкод;
			НомерСимвола = СтрДлина(СтрокаШтрихкод);
		КонецЕсли;
		
		СтруктураТовара.barCodes.Добавить(Штрихкод);
		
		СтрокаШтрихкод = Прав(СтрокаШтрихкод, СтрДлина(СтрокаШтрихкод) - НомерСимвола);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЗаполнитьСтруктуруОтвета(ТекстJSON, ВыходныеПараметры) Экспорт
	
	Попытка
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ТекстJSON);
		ПоляДат = Новый Массив;
		ПоляДат.Добавить("openDate");
		ПоляДат.Добавить("closeDate");
		ПоляДат.Добавить("creationDate");
		ВыходныеПараметры = ПрочитатьJSON(ЧтениеJSON,,ПоляДат);
		ЧтениеJSON.Закрыть();
	Исключение
		ТекстСообщения = НСтр("ru = 'Не удалось прочитать файл ответа'");
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, ТекстСообщения);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ПолучитьТовар()
	
	СтруктураТовара = Новый Структура;
	СтруктураТовара.Вставить("uuid");
	СтруктураТовара.Вставить("code");
	СтруктураТовара.Вставить("barCodes",  Новый Массив);
	СтруктураТовара.Вставить("alcoCodes", Новый Массив);
	СтруктураТовара.Вставить("name");
	СтруктураТовара.Вставить("price");
	СтруктураТовара.Вставить("quantity", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 3)));
	СтруктураТовара.Вставить("costPrice");
	СтруктураТовара.Вставить("measureName");
	СтруктураТовара.Вставить("tax");
	СтруктураТовара.Вставить("allowToSell");
	СтруктураТовара.Вставить("description");
	СтруктураТовара.Вставить("articleNumber");
	СтруктураТовара.Вставить("parentUuid");
	СтруктураТовара.Вставить("group");
	СтруктураТовара.Вставить("type");
	СтруктураТовара.Вставить("alcoholByVolume");
	СтруктураТовара.Вставить("alcoholProductKindCode");
	СтруктураТовара.Вставить("tareVolume");
	
	Возврат СтруктураТовара;
	
КонецФункции

Функция ОбработатьДанныеЗапроса(МассивДанных, ДополнительныеПараметры) Экспорт
	
	СтруктураВозвращаемыхДанных = Новый Массив;
	Если ДополнительныеПараметры.НаименованиеКоманды = "ЗагрузитьРасширенныйОтчет" Тогда
		
		СтруктураДанных = Новый Массив;
		СоответствиеСмен = Новый Соответствие;
		
		Для Каждого Документ Из МассивДанных Цикл
			Если Документ.type = "OPEN_SESSION" Тогда
				СтруктураОтчета = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруОтчетаОПродажах();
				СтруктураОтчета.ДатаОткрытияСмены = Документ.openDate;
				СтруктураОтчета.НомерСмены        = Документ.sessionNumber;
				СоответствиеСмен.Вставить(Документ.sessionUUID, СтруктураОтчета);
				СтруктураДанных.Добавить(СтруктураОтчета);
			ИначеЕсли Документ.type = "SELL" ИЛИ Документ.type = "PAYBACK" Тогда
				
				СтруктураОтчета = СоответствиеСмен.Получить(Документ.sessionUUID);
				Если Не ЗначениеЗаполнено(СтруктураОтчета) Тогда
					СтруктураОтчета = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруОтчетаОПродажах();
					СтруктураОтчета.НомерСмены        = Документ.sessionNumber;
					СоответствиеСмен.Вставить(Документ.sessionUUID, СтруктураОтчета);
					СтруктураДанных.Добавить(СтруктураОтчета);
				КонецЕсли;
				ЗаписьОплаты = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваОплаты();
				
				Для Каждого Транзакция Из Документ.transactions Цикл
					Если Транзакция.type = "REGISTER_POSITION" Тогда
						СтруктураЗаписиТовара = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваТоварыОтчетаОПродажах();
						СтруктураЗаписиТовара.Код                          = Транзакция.commodityCode;
						СтруктураЗаписиТовара.Количество                   = Транзакция.quantity;
						СтруктураЗаписиТовара.Сумма                        = Транзакция.resultSum;
						СтруктураЗаписиТовара.Цена                         = Транзакция.price;
						СтруктураЗаписиТовара.ШтрихкодАлкогольнойПродукции = Транзакция.mark;
						СтруктураОтчета.Товары.Добавить(СтруктураЗаписиТовара);
					ИначеЕсли Транзакция.type = "PAYMENT" Тогда
						Если Транзакция.paymentType = "CASH" Тогда
							ЗаписьОплаты.ТипОплаты = "0";
						ИначеЕсли Транзакция.paymentType = "CARD" Тогда
							ЗаписьОплаты.ТипОплаты = "1";
						КонецЕсли;
						Если Не ЗаписьОплаты.Сумма = Неопределено Тогда
							ЗаписьОплаты.Сумма = ЗаписьОплаты.Сумма + Транзакция.sum;
						Иначе
							ЗаписьОплаты.Сумма = Транзакция.sum;
						КонецЕсли;
						ЗаписьОплаты.КодВидаОплаты = 0;
						
					КонецЕсли;
				КонецЦикла;
				СтруктураОтчета.Оплаты.Добавить(ЗаписьОплаты);
				
			ИначеЕсли Документ.type = "CLOSE_SESSION" Тогда
				СтруктураОтчета = СоответствиеСмен.Получить(Документ.sessionUUID);
				Если ЗначениеЗаполнено (СтруктураОтчета) Тогда
					СтруктураОтчета.ДатаЗакрытияСмены = Документ.openDate;
				КонецЕсли;
			ИначеЕсли Документ.type = "OPEN_TARE" Тогда
				СтруктураОтчета = СоответствиеСмен.Получить(Документ.SessionUUID);
				Если Не ЗначениеЗаполнено(СтруктураОтчета) Тогда
					СтруктураОтчета = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруОтчетаОПродажах();
					СтруктураОтчета.НомерСмены        = Документ.sessionNumber;
					СоответствиеСмен.Вставить(Документ.sessionUUID, СтруктураОтчета);
					СтруктураДанных.Добавить(СтруктураОтчета);
				КонецЕсли;
				Для Каждого Транзакция Из Документ.transactions Цикл
				
					Если Транзакция.type = "REGISTER_POSITION" Тогда
						СтруктураЗаписиВскрытияТары = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваВскрытияТары();
						СтруктураЗаписиВскрытияТары.Дата       = Транзакция.creationDate;
						СтруктураЗаписиВскрытияТары.Код        = Транзакция.commodityCode;
						СтруктураЗаписиВскрытияТары.Количество = Транзакция.quantity;
						СтруктураЗаписиВскрытияТары.ШтрихкодАлкогольнойПродукции = Транзакция.barcode;
						СтруктураОтчета.ВскрытияТары.Добавить(СтруктураЗаписиВскрытияТары);
					КонецЕсли;
				
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
		СтруктураВозвращаемыхДанных.Добавить(СтруктураДанных);
		
	ИначеЕсли ДополнительныеПараметры.НаименованиеКоманды = "ЗагрузитьОтчет" Тогда
		
		СтруктураДанных = Новый Массив;
		
		Для Каждого Документ Из МассивДанных Цикл
			Если Документ.type = "SELL" Тогда
				
				Для Каждого Транзакция Из Документ.transactions Цикл
					Если Транзакция.type = "REGISTER_POSITION" Тогда
						СтруктураЗаписи = Новый Структура("Код, Цена, Количество, Скидка, Сумма");
						СтруктураЗаписи.Код                          = Транзакция.commodityCode;
						СтруктураЗаписи.Количество                   = Транзакция.quantity;
						СтруктураЗаписи.Сумма                        = Транзакция.resultSum;
						СтруктураЗаписи.Цена                         = Транзакция.price;
						Скидка = (СтруктураЗаписи.Цена * СтруктураЗаписи.Количество) - СтруктураЗаписи.Сумма;
						СтруктураЗаписи.Скидка = ?(Скидка < 0, -Скидка, Скидка);
						СтруктураДанных.Добавить(СтруктураЗаписи);
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
		КонецЦикла;
		
		СтруктураВозвращаемыхДанных.Добавить(СтруктураДанных);
		
	ИначеЕсли ДополнительныеПараметры.НаименованиеКоманды = "ЗагрузитьМагазины" Тогда
		
		СтруктураВозвращаемыхДанных = МассивДанных;
		
	ИначеЕсли ДополнительныеПараметры.НаименованиеКоманды = "ЗагрузитьТерминалы" Тогда
		
		СтруктураВозвращаемыхДанных = МассивДанных;
		
	ИначеЕсли ДополнительныеПараметры.НаименованиеКоманды = "ТестУстройства" Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат СтруктураВозвращаемыхДанных;
	
КонецФункции

// Процедура добавляет в массив выходных параметров сообщение об ошибке.
//		Параметры:
//			- ВыходныеПараметры - массив, в который будет помещено сообщение об ошибке.
//			- ТекстСообщения - текст сообщения, содержащий информация об ошибке.
Процедура СоздатьСообщениеОбОшибке(ВыходныеПараметры, ТекстСообщения)
	
	ВыходныеПараметры.Добавить(999);
	ВыходныеПараметры.Добавить(ТекстСообщения);
	
КонецПроцедуры

// Функция возвращает дату в формате JSON-даты с добавлением смещения по часовому поясу.
//
Функция ПреобразоватьДату(Дата) Экспорт
	
	Смещение = СмещениеСтандартногоВремени(ЧасовойПоясСеанса(),УниверсальноеВремя(ТекущаяДатаСеанса()))/60/60;
	
	Если Смещение < 0 Тогда
		Знак = "%2D";
		Смещение = Смещение * (-1);
	Иначе
		Знак = "%2B";
	КонецЕсли;
	КоличествоЧасов = ?(Смещение > 9, Строка(Смещение), "0" + Строка(Смещение));
	
	СмещениеЧасов = ".000" + Знак + КоличествоЧасов + "00";
	
	ФорматированнаяДата = Формат(Дата, "ДФ=гггг-ММ-дд") + "T" + Формат(Дата, "ДФ=ЧЧ:мм:сс") + СмещениеЧасов;
	
	Возврат ФорматированнаяДата;
	
КонецФункции
#КонецОбласти