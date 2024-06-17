﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Возвращает строку уникального идентификатора
// предопределенной группы ВсеПользователи.
//
// Возвращаемое значение:
//  Строка - строка уникального идентификатора.
//
Функция ИдентификаторГруппыВсеПользователи()
	
	Возврат "515b9805-054f-424e-816e-87afebdac3b6";
	
КонецФункции

// Параметры:
//  ИмяГруппы - Строка - "ВсеВнешниеПользователи", "ВсеПользователи".
//
// Возвращаемое значение:
//  СправочникСсылка.ГруппыПользователей
//  СправочникСсылка.ГруппыВнешнихПользователей
//
Функция СтандартнаяГруппаПользователей(ИмяГруппы) Экспорт
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	
	Если ИмяГруппы = "ВсеВнешниеПользователи" Тогда
		ИдентификаторГруппы = Справочники.ГруппыВнешнихПользователей.ИдентификаторГруппыВсеВнешниеПользователи();
		ПолноеИмяСправочника = "Справочник.ГруппыВнешнихПользователей";
		МенеджерСправочника = Справочники.ГруппыВнешнихПользователей;
		НаименованиеГруппы = НСтр("ru = 'Все внешние пользователи'", ОбщегоНазначения.КодОсновногоЯзыка());
		
	ИначеЕсли ИмяГруппы = "ВсеПользователи" Тогда
		ИдентификаторГруппы = ИдентификаторГруппыВсеПользователи();
		ПолноеИмяСправочника = "Справочник.ГруппыПользователей";
		МенеджерСправочника = Справочники.ГруппыПользователей;
		НаименованиеГруппы = НСтр("ru = 'Все пользователи'", ОбщегоНазначения.КодОсновногоЯзыка());
	Иначе
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неизвестное имя стандартной группы ""%1"".'"), ИмяГруппы);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИмяПредопределенныхДанных", ИмяГруппы);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыПользователей.Ссылка КАК Ссылка
	|ИЗ
	|	&Таблица КАК ГруппыПользователей
	|ГДЕ
	|	ГруппыПользователей.ИмяПредопределенныхДанных = &ИмяПредопределенныхДанных
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Таблица", ПолноеИмяСправочника);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыПользователей.Ссылка КАК Ссылка,
	|	ГруппыПользователей.Наименование КАК Наименование
	|ИЗ
	|	&Таблица КАК ГруппыПользователей
	|ГДЕ
	|	ГруппыПользователей.ИмяПредопределенныхДанных = &ИмяПредопределенныхДанных
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Таблица", ПолноеИмяСправочника);
	
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить(ПолноеИмяСправочника);
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Выборка = Запрос.Выполнить().Выбрать();
		
		СсылкаНового = МенеджерСправочника.ПолучитьСсылку(
			Новый УникальныйИдентификатор(ИдентификаторГруппы));
		
		Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
			ГруппаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			
		ИначеЕсли Выборка.Количество() > 1 Тогда
			ГруппаОбъект = ГруппаИзДублейПредопределенного(Выборка, НаименованиеГруппы, СсылкаНового);
		Иначе
			ГруппаОбъект = СсылкаНового.ПолучитьОбъект();
			Если ГруппаОбъект = Неопределено Тогда
				ГруппаПоНаименованию = ГруппаПоНаименованию(НаименованиеГруппы, ПолноеИмяСправочника);
				Если ЗначениеЗаполнено(ГруппаПоНаименованию) Тогда
					ГруппаОбъект = ГруппаПоНаименованию.ПолучитьОбъект();
				КонецЕсли;
			КонецЕсли;
			Если ГруппаОбъект = Неопределено Тогда
				ГруппаОбъект = МенеджерСправочника.СоздатьЭлемент();
				ГруппаОбъект.УстановитьСсылкуНового(СсылкаНового);
			КонецЕсли;
		КонецЕсли;
		Если ГруппаОбъект.ИмяПредопределенныхДанных <> ИмяГруппы Тогда
			ГруппаОбъект.ИмяПредопределенныхДанных = ИмяГруппы;
		КонецЕсли;
		Если ГруппаОбъект.Наименование <> НаименованиеГруппы Тогда
			ГруппаОбъект.Наименование = НаименованиеГруппы;
		КонецЕсли;
		Если ЗначениеЗаполнено(ГруппаОбъект.Состав) Тогда
			ГруппаОбъект.Состав.Очистить();
		КонецЕсли;
		Если ЗначениеЗаполнено(ГруппаОбъект.Комментарий) Тогда
			ГруппаОбъект.Комментарий = "";
		КонецЕсли;
		Если ГруппаОбъект.Модифицированность() Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ГруппаОбъект);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат ГруппаОбъект.Ссылка;
	
КонецФункции

// Для функции СтандартнаяГруппаПользователей.
Функция ГруппаИзДублейПредопределенного(Выборка, НаименованиеГруппы, СсылкаНового)
	
	ГруппаПоПорядку = Неопределено;
	ГруппаПоСсылкеНового = Неопределено;
	ГруппаПоНаименованию = Неопределено;
	
	ОбъектыДляОтвязки = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		ОбъектыДляОтвязки.Вставить(Выборка.Ссылка, Истина);
		Если ГруппаПоПорядку = Неопределено Тогда
			ГруппаПоПорядку = Выборка.Ссылка;
		КонецЕсли;
		Если Выборка.Ссылка = СсылкаНового Тогда
			ГруппаПоСсылкеНового = Выборка.Ссылка;
		ИначеЕсли Выборка.Наименование = НаименованиеГруппы
		        И ГруппаПоНаименованию = Неопределено Тогда
			ГруппаПоНаименованию = НаименованиеГруппы;
		КонецЕсли;
	КонецЦикла;
	
	Если ГруппаПоСсылкеНового <> Неопределено Тогда
		ГруппаОбъект = ГруппаПоСсылкеНового.ПолучитьОбъект();
		ОбъектыДляОтвязки.Удалить(ГруппаПоСсылкеНового);
		
	ИначеЕсли ГруппаПоНаименованию <> Неопределено Тогда
		ГруппаОбъект = ГруппаПоНаименованию.ПолучитьОбъект();
		ОбъектыДляОтвязки.Удалить(ГруппаПоНаименованию);
	Иначе
		ГруппаОбъект = ГруппаПоПорядку.ПолучитьОбъект();
		ОбъектыДляОтвязки.Удалить(ГруппаПоПорядку);
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из ОбъектыДляОтвязки Цикл
		ТекущийОбъект = КлючИЗначение.Ключ.ПолучитьОбъект();
		ТекущийОбъект.ИмяПредопределенныхДанных = "";
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ТекущийОбъект);
	КонецЦикла;
	
	Возврат ГруппаОбъект;
	
КонецФункции

// Для функции СтандартнаяГруппаПользователей.
Функция ГруппаПоНаименованию(Наименование, ПолноеИмяСправочника)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Наименование", Наименование);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ГруппыПользователей.Ссылка КАК Ссылка
	|ИЗ
	|	&Таблица КАК ГруппыПользователей
	|ГДЕ
	|	ГруппыПользователей.Наименование = &Наименование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Таблица", ПолноеИмяСправочника);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов
// 
// Параметры:
//  Настройки - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов.Настройки
//
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт

	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ВсеПользователи";
	Элемент.Наименование = НСтр("ru = 'Все пользователи'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецПроцедуры

#КонецОбласти


#КонецЕсли
