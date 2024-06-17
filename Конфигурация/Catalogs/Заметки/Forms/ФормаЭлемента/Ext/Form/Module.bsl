﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Предмет) Тогда
		Объект.Предмет = Параметры.Предмет;
		Объект.ПредставлениеПредмета = ОбщегоНазначения.ПредметСтрокой(Объект.Предмет);
	КонецЕсли;
	
	Элементы.Предмет.Заголовок = Объект.ПредставлениеПредмета;
	Элементы.ГруппаПредмет.Видимость = ЗначениеЗаполнено(Объект.Предмет);
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Автор = Пользователи.ТекущийПользователь();
		ФорматированныйТекст = Параметры.ЗначениеКопирования.Содержание.Получить();
		
		Элементы.ДатаЗаметки.Заголовок = НСтр("ru = 'Не записано'")
	Иначе
		Элементы.ДатаЗаметки.Заголовок = НСтр("ru = 'Записано'") + ": " + Формат(Объект.ДатаИзменения, "ДЛФ=DDT");
	КонецЕсли;
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ФорматированныйТекст = ТекущийОбъект.Содержание.Получить();

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Содержание = Новый ХранилищеЗначения(ФорматированныйТекст, Новый СжатиеДанных(9));
	
	ТекстHTML = "";
	Вложения = Новый Структура;
	ФорматированныйТекст.ПолучитьHTML(ТекстHTML, Вложения);
	
	ТекущийОбъект.ТекстСодержания = СтроковыеФункцииКлиентСервер.ИзвлечьТекстИзHTML(ТекстHTML);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	Элементы.ДатаЗаметки.Заголовок = НСтр("ru = 'Записано'") + ": " + Формат(Объект.ДатаИзменения, "ДЛФ=DDT");
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОповеститьОбИзменении(Объект.Ссылка);
	Если ЗначениеЗаполнено(Объект.Предмет) Тогда
		ОповеститьОбИзменении(Объект.Предмет);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредметНажатие(Элемент)
	ПоказатьЗначение(,Объект.Предмет);
КонецПроцедуры

&НаКлиенте
Процедура АвторНажатие(Элемент)
	ПоказатьЗначение(,Объект.Автор);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимость()
	Элементы.Автор.Заголовок = Объект.Автор;
	ОткрытаАвтором = Объект.Автор = Пользователи.ТекущийПользователь();
	Элементы.ПараметрыОтображения.Видимость = ОткрытаАвтором;
	Элементы.ИнформацияОбАвторе.Видимость = Не ОткрытаАвтором;
	
	ТолькоПросмотр = Не ОткрытаАвтором;
	Элементы.Содержание.ТолькоПросмотр = Не ОткрытаАвтором;
	Элементы.КоманднаяПанельРедактирования.Видимость = ОткрытаАвтором;
КонецПроцедуры

#КонецОбласти
