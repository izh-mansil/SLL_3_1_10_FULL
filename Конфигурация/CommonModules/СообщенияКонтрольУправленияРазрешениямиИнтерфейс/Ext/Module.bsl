﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК ИНТЕРФЕЙСА СООБЩЕНИЙ КОНТРОЛЯ УПРАВЛЕНИЯ РАЗРЕШЕНИЯМИ
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
//
// Возвращаемое значение:
//	Строка - 
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/Application/Permissions/Control/" + Версия(); // @Non-NLS-1
	
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений.
//
// Возвращаемое значение:
//	Строка - 
Функция Версия() Экспорт
	
	Возврат "1.0.0.1";
	
КонецФункции

// Возвращает название программного интерфейса сообщений.
//
// Возвращаемое значение:
//	Строка - 
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "ApplicationPermissionsControl";
	
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
//
// Параметры:
//  МассивОбработчиков - Массив - массив обработчиков.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияКонтрольУправленияРазрешениямиОбработчикСообщения_1_0_0_1);
	
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  МассивОбработчиков - Массив - массив обработчиков.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/Application/Permissions/Control/a.b.c.d}InfoBasePermissionsRequestProcessed
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипЗначенияXDTO, ТипОбъектаXDTO - тип сообщения.
//
Функция СообщениеОбработанЗапросРазрешенийИнформационнойБазы(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "InfoBasePermissionsRequestProcessed");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/Application/Permissions/Control/a.b.c.d}ApplicationPermissionsRequestProcessed
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипЗначенияXDTO, ТипОбъектаXDTO - тип сообщения.
//
Функция СообщениеОбработанЗапросРазрешенийОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ApplicationPermissionsRequestProcessed");
	
КонецФункции

// Словарь преобразования элементов перечисления  схемы
// {http://www.1c.ru/1cFresh/Application/Permissions/Control/1.0.0.1}PermissionRequestProcessingResultTypes
// в элементы перечисления РезультатыОбработкиЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура - с полями:
//	* Approved - ПеречислениеСсылка.РезультатыОбработкиЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса - одобрен.
//	* Rejected - ПеречислениеСсылка.РезультатыОбработкиЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса - отклонен.
Функция СловарьТиповРезультатовОбработкиЗапросов() Экспорт
	
	Результат = Новый Структура();
	
	Результат.Вставить("Approved", Перечисления.РезультатыОбработкиЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса.ЗапросОдобрен);
	Результат.Вставить("Rejected", Перечисления.РезультатыОбработкиЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса.ЗапросОтклонен);
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет, Знач Тип)
	
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции

#КонецОбласти
