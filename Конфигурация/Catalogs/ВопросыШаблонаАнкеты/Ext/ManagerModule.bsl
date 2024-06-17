﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Обязательный");
	Результат.Добавить("Заметки");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления.

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВопросыШаблонаАнкеты.Ссылка
		|ИЗ
		|	Справочник.ВопросыШаблонаАнкеты КАК ВопросыШаблонаАнкеты
		|ГДЕ
		|	ВопросыШаблонаАнкеты.СпособОтображенияПодсказки = &ПустаяСсылка";
	Запрос.Параметры.Вставить("ПустаяСсылка", Перечисления.СпособыОтображенияПодсказок.ПустаяСсылка());
	
	Результат = Запрос.Выполнить().Выгрузить();
	МассивСсылок = Результат.ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

// Заполнить значение нового реквизита СпособОтображенияПодсказки у справочника ВопросыШаблонаАнкеты.
// 
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.ВопросыШаблонаАнкеты");
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	Пока Выборка.Следующий() Цикл
		ПредставлениеСсылки = Строка(Выборка.Ссылка);
		Попытка
			
			ЗаполнитьРеквизитСпособОтображенияПодсказки(Выборка);
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
		Исключение
			
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ОбновлениеИнформационнойБазы.ЗаписатьОшибкуВЖурналРегистрации(
				Выборка.Ссылка,
				ПредставлениеСсылки,
				ИнформацияОбОшибке());
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ВопросыШаблонаАнкеты");
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать некоторые вопросы шаблона анкеты (пропущены): %1'"), 
				ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.ВопросыШаблонаАнкеты,,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Обработана очередная порция вопросов шаблона анкеты: %1'"),
					ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет значение нового реквизита СпособОтображенияПодсказки у переданного объекта.
//
Процедура ЗаполнитьРеквизитСпособОтображенияПодсказки(Выборка)
	
	НачатьТранзакцию();
	Попытка
	
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ВопросыШаблонаАнкеты");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
		Блокировка.Заблокировать();
		
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		Если СправочникОбъект.СпособОтображенияПодсказки <> Перечисления.СпособыОтображенияПодсказок.ПустаяСсылка() Тогда
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			Возврат;
		КонецЕсли;
		
		СправочникОбъект.СпособОтображенияПодсказки = Перечисления.СпособыОтображенияПодсказок.КонтекстнаяПодсказка;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СправочникОбъект);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
