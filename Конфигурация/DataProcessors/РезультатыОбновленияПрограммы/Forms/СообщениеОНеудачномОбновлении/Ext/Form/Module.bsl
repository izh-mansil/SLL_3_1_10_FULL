﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОтчетОбОшибке;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Переход в режим открытия формы повторной синхронизации данных перед запуском
	// с двумя вариантами "Синхронизировать и продолжить" и "Продолжить".
	Если Параметры.ИнформацияОбОшибке <> Неопределено Тогда
		КраткоеПредставлениеОшибки   = ОбработкаОшибок.КраткоеПредставлениеОшибки(Параметры.ИнформацияОбОшибке);
		ПодробноеПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(Параметры.ИнформацияОбОшибке);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПодробноеПредставлениеОшибки)
	   И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными")
	   И ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
		МодульОбменДаннымиСервер.ВключитьПовторениеЗагрузкиСообщенияОбменаДаннымиПередЗапуском();
	КонецЕсли;
	
	ИнформацияОбОшибке = Параметры.ИнформацияОбОшибке;
	
	Если ЗначениеЗаполнено(ПодробноеПредставлениеОшибки) Тогда
		ЖурналРегистрации.ДобавитьСообщениеДляЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
			, , ПодробноеПредставлениеОшибки);
	КонецЕсли;
	
	ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Приложение не было обновлено на новую версию по причине:
		|
		|%1'"),
		КраткоеПредставлениеОшибки);
	
	Элементы.ТекстСообщенияОбОшибке.Заголовок = ТекстСообщенияОбОшибке;
	
	ВремяНачалаОбновления = Параметры.ВремяНачалаОбновления;
	ВремяОкончанияОбновления = ТекущаяДатаСеанса();
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		Элементы.ФормаОткрытьВнешнююОбработку.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
		ИспользуютсяПрофилиБезопасности = МодульРаботаВБезопасномРежиме.ИспользуютсяПрофилиБезопасности();
	Иначе
		ИспользуютсяПрофилиБезопасности = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеКонфигурации") Тогда
		МодульОбновлениеКонфигурации = ОбщегоНазначения.ОбщийМодуль("ОбновлениеКонфигурации");
		КаталогСкрипта = МодульОбновлениеКонфигурации.КаталогСкрипта();
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеКонфигурации")
		И Не ОбщегоНазначения.РазделениеВключено()
		И Не ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		МодульИнтернетПоддержкаПользователейКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователейКлиентСервер");
		ВерсияБИП = МодульИнтернетПоддержкаПользователейКлиентСервер.ВерсияБиблиотеки();
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияБИП, "2.6.3.0") < 0
			Или Не Пользователи.ЭтоПолноправныйПользователь() Тогда
			Элементы.ФормаПроверитьНаличиеИсправлений.Видимость = Ложь;
		Иначе
			ДанныеАутентификации = МодульИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
			
			Если ДанныеАутентификации = Неопределено Тогда
				Элементы.ФормаПроверитьНаличиеИсправлений.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Элементы.ФормаПроверитьНаличиеИсправлений.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПустаяСтрока(КаталогСкрипта) Тогда
		МодульОбновлениеКонфигурацииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбновлениеКонфигурацииКлиент");
		МодульОбновлениеКонфигурацииКлиент.ЗаписатьФайлПротоколаОшибкиИЗавершитьРаботу(КаталогСкрипта, 
			ПодробноеПредставлениеОшибки);
	КонецЕсли;
	
	Если ИнформацияОбОшибке <> Неопределено Тогда
		ОтчетОбОшибке = Новый ОтчетОбОшибке(ИнформацияОбОшибке);
		СтандартныеПодсистемыКлиент.НастроитьВидимостьИЗаголовокСсылкиОтправкиОтчетаОбОшибке(Элементы.СформироватьОтчетОбОшибке, ИнформацияОбОшибке, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ОтчетОбОшибке <> Неопределено Тогда
		СтандартныеПодсистемыКлиент.ОтправитьОтчетОбОшибке(ОтчетОбОшибке, ИнформацияОбОшибке, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказатьСведенияОРезультатахОбновленияНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаНачала", ВремяНачалаОбновления);
	ПараметрыФормы.Вставить("ДатаОкончания", ВремяОкончанияОбновления);
	ПараметрыФормы.Вставить("ЗапускатьНеВФоне", Истина);
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы,,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	Закрыть(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПерезагрузитьПрограмму(Команда)
	Закрыть(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешнююОбработку(Команда)
	
	ОбработкаПродолжения = Новый ОписаниеОповещения("ОткрытьВнешнююОбработкуПослеПодтвержденияБезопасности", ЭтотОбъект);
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ПредупреждениеБезопасности",,,,,, ОбработкаПродолжения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешнююОбработкуПослеПодтвержденияБезопасности(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ИспользуютсяПрофилиБезопасности Тогда
		
		МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
		МодульРаботаВБезопасномРежимеКлиент.ОткрытьВнешнююОбработкуИлиОтчет(ЭтотОбъект);
		Возврат;
		
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьВнешнююОбработкуЗавершение", ЭтотОбъект);
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Внешняя обработка'") + "(*.epf)|*.epf";
	ПараметрыЗагрузки.Диалог.МножественныйВыбор = Ложь;
	ПараметрыЗагрузки.Диалог.Заголовок = НСтр("ru = 'Выберите внешнюю обработку'");
	ФайловаяСистемаКлиент.ЗагрузитьФайл(Оповещение, ПараметрыЗагрузки);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешнююОбработкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ИмяВнешнейОбработки = ПодключитьВнешнююОбработку(Результат.Хранение);
		ОткрытьФорму(ИмяВнешнейОбработки + ".Форма");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНаличиеИсправлений(Команда)
	Результат = ДоступныеИсправленияНаСервере();
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Ошибка Тогда
		ПоказатьПредупреждение(, Результат.КраткоеОписаниеОшибки);
		Возврат;
	КонецЕсли;
	
	ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
	ПараметрыВопроса.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
	ПараметрыВопроса.Заголовок = НСтр("ru = 'Проверка наличия исправлений'");
	ПараметрыВопроса.Картинка = БиблиотекаКартинок.Информация;
	
	Если Результат.КоличествоИсправлений = 0 Тогда
		Сообщение = НСтр("ru = 'Доступных исправлений (патчей) не найдено.'");
		СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(Неопределено, Сообщение, РежимДиалогаВопрос.ОК, ПараметрыВопроса);
		Возврат;
	КонецЕсли;
	
	Сообщение = НСтр("ru = 'Найдено исправлений: %1. Выполнить установку?'");
	Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Сообщение, Результат.КоличествоИсправлений);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьДоступныеИсправленияПродолжение", ЭтотОбъект, Результат);
	
	ПараметрыВопроса.Картинка = БиблиотекаКартинок.ДиалогВопрос;
	ПараметрыВопроса.КнопкаПоУмолчанию = КодВозвратаДиалога.Да;
	СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(ОписаниеОповещения, Сообщение, РежимДиалогаВопрос.ДаНет, ПараметрыВопроса);
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчетОбОшибкеНажатие(Элемент)
	СтандартныеПодсистемыКлиент.ПоказатьОтчетОбОшибке(ОтчетОбОшибке);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДоступныеИсправленияНаСервере()
	Результат = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы") Тогда
		МодульПолучениеОбновленийПрограммы = ОбщегоНазначения.ОбщийМодуль("ПолучениеОбновленийПрограммы");
		Результат = МодульПолучениеОбновленийПрограммы.ИнформацияОДоступныхИсправлениях();
		Если Результат <> Неопределено Тогда
			Исправления = Результат.Исправления.ВыгрузитьКолонку("Наименование");
			Результат.Вставить("КоличествоИсправлений", Результат.Исправления.Количество());
			Результат.Вставить("Исправления", Исправления);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ПроверитьДоступныеИсправленияПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Значение = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация    = ЗапускУстановкиИсправлений();
	ПараметрыОжидания     = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультат", ЭтотОбъект, ДополнительныеПараметры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ЗапускУстановкиИсправлений()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Установка доступных исправлений после ошибки обновления.'");
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "ПолучениеОбновленийПрограммы.ЗагрузитьИУстановитьИсправления");
	
КонецФункции

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовыйРезультатДлительнойОперации
//  ДополнительныеПараметры - Неопределено
//
&НаКлиенте
Процедура ОбработатьРезультат(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
	ПараметрыВопроса.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
	ПараметрыВопроса.Заголовок = НСтр("ru = 'Установка исправлений'");
	
	Если Результат.Статус = "Ошибка" Тогда
		СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(
			Результат.ИнформацияОбОшибке);
		Возврат;
	КонецЕсли;
	
	РезультатУстановки = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	Если РезультатУстановки.Ошибка Тогда
		ТекстОшибки = РезультатУстановки.КраткоеОписаниеОшибки
			+ Символы.ПС + Символы.ПС + НСтр("ru = 'Технические подробности о проблеме см. в журнале регистрации.'");
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("ЖурналРегистрации", НСтр("ru = 'Журнал регистрации'"));
		Кнопки.Добавить("Закрыть", НСтр("ru = 'Закрыть'"));
		ПараметрыВопроса.Картинка = БиблиотекаКартинок.ДиалогВосклицание;
		ПараметрыВопроса.КнопкаПоУмолчанию = "Закрыть";
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьОшибкуУстановкиПатчей", ЭтотОбъект);
		СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(ОписаниеОповещения, ТекстОшибки, Кнопки, ПараметрыВопроса);
		
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Исправления", ДополнительныеПараметры.Исправления);
	ПараметрыОткрытия.Вставить("ПриОбновлении", Истина);
	МодульОбновлениеКонфигурацииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбновлениеКонфигурацииКлиент");
	МодульОбновлениеКонфигурацииКлиент.ПоказатьУстановленныеИсправления(ПараметрыОткрытия, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОшибкуУстановкиПатчей(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Значение = "ЖурналРегистрации" Тогда
		ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПодключитьВнешнююОбработку(АдресВоВременномХранилище)
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа.'");
	КонецЕсли;
	
	// АПК:552-выкл сценарий ремонта базы при ошибках обновления для полноправного администратора.
	// АПК:556-выкл
	Менеджер = ВнешниеОбработки;
	ИмяОбработки = Менеджер.Подключить(АдресВоВременномХранилище, , Ложь,
		ОбщегоНазначения.ОписаниеЗащитыБезПредупреждений());
	Возврат Менеджер.Создать(ИмяОбработки, Ложь).Метаданные().ПолноеИмя();
	// АПК:556-вкл
	// АПК:552-вкл
	
КонецФункции

#КонецОбласти
