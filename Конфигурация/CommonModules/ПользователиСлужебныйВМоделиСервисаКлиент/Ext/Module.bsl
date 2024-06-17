﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму ввода пароля пользователя сервиса.
//
// Параметры:
//  ОбработкаПродолжения      - ОписаниеОповещения - которое нужно обработать после получения пароля.
//  ФормаВладелец             - ФормаКлиентскогоПриложения - которая запрашивает пароль.
//  ПарольПользователяСервиса - Строка - текущий пароль пользователя сервиса.
//
Процедура ЗапроситьПарольДляАутентификацииВСервисе(ОбработкаПродолжения, ФормаВладелец, ПарольПользователяСервиса) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОбработкаПродолжения", ОбработкаПродолжения);
	Контекст.Вставить("ФормаВладелец", ФормаВладелец);
	Контекст.Вставить("ПарольПользователяСервиса", ПарольПользователяСервиса);
	
	Если ПарольПользователяСервиса = Неопределено Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеЗапросаПароляДляАутентификацииВСервисе", ЭтотОбъект, Контекст);
		ОткрытьФорму("ОбщаяФорма.АутентификацияВСервисе", , ФормаВладелец, , , , Оповещение);
	Иначе
		ПослеЗапросаПароляДляАутентификацииВСервисе(ПарольПользователяСервиса, Контекст)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПослеЗапросаПароляДляАутентификацииВСервисе(ПарольПользователяСервиса, Контекст) Экспорт
	
	Контекст.ПарольПользователяСервиса = ПарольПользователяСервиса;
	
	Оповещение = Новый ОписаниеОповещения(
		"ПослеЗапросаПароляДляАутентификацииВСервисеПродолжение", ЭтотОбъект, Контекст);
	
	СтандартныеПодсистемыКлиент.НачатьВыполнениеОбработкиОповещения(Оповещение);
	
КонецПроцедуры

Процедура ПослеЗапросаПароляДляАутентификацииВСервисеПродолжение(Результат, Контекст) Экспорт

	ТекстОшибки = "";
	Попытка
		ВыполнитьОбработкуОповещения(Контекст.ОбработкаПродолжения, Контекст.ПарольПользователяСервиса);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПользователиСлужебныйВМоделиСервисаВызовСервера.ЗаписатьОшибкуВЖурнал(
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ТекстОшибки = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке) + Символы.ПС
			+ НСтр("ru = 'Возможно пароль введен неверно, повторите ввод пароля.'");
	КонецПопытки;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеЗапросаПароляДляАутентификацииВСервисеИПредупрежденияОбОшибке", ЭтотОбъект, Контекст);
		ПоказатьПредупреждение(Оповещение, ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеЗапросаПароляДляАутентификацииВСервисеИПредупрежденияОбОшибке(Контекст) Экспорт
	
	ЗапроситьПарольДляАутентификацииВСервисе(Контекст.ОбработкаПродолжения,
		Контекст.ФормаВладелец, Неопределено);
	
КонецПроцедуры

#КонецОбласти
