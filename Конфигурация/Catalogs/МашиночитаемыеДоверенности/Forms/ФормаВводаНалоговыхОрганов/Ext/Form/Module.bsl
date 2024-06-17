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

	Если Параметры.ТолькоПросмотрФормы Тогда
		Элементы.ТипНалоговыхОргановДействия.ТолькоПросмотр = Истина;
		Элементы.НалоговыеОрганыДействия.ТолькоПросмотр     = Истина;
		Элементы.ФормаКнопкаСохранить.Доступность           = Ложь;
	КонецЕсли;
	
	Если Параметры.КодыНалоговыхОргановДействия <> Неопределено Тогда
		ТипНалоговыхОргановДействия = ?(Параметры.КодыНалоговыхОргановДействия.Количество() > 0, "1", "0");
	Иначе
		ТипНалоговыхОргановДействия = "0";
	КонецЕсли;
	
	МашиночитаемыеДоверенностиФНСПереопределяемый.ПриЗаполненииНалоговыхОргановДействия(Параметры.Организации, НалоговыеОрганыДействия);
	
	Если Параметры.КодыНалоговыхОргановДействия <> Неопределено Тогда
		Для Каждого КодНалоговогоОрганаДействия Из Параметры.КодыНалоговыхОргановДействия Цикл
			ПараметрыОтбора = Новый Структура("Код", КодНалоговогоОрганаДействия);
			Если НалоговыеОрганыДействия.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда
				НалоговыйОрганДействия = НалоговыеОрганыДействия.Добавить();
				НалоговыйОрганДействия.Пометка = Истина;
				НалоговыйОрганДействия.Код = КодНалоговогоОрганаДействия;
				НалоговыйОрганДействия.Наименование = "";
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипНалоговыхОргановДействияПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Добавить(Команда)
	
	НоваяСтрока = НалоговыеОрганыДействия.Добавить();
	НоваяСтрока.Пометка = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого Стр Из НалоговыеОрганыДействия Цикл
		Стр.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого Стр Из НалоговыеОрганыДействия Цикл
		Стр.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если Не СохранениеВозможно() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("КодыНалоговыхОргановДействия", Новый Массив);
	
	Если ТипНалоговыхОргановДействия = "1" Тогда
		Для каждого Стр Из НалоговыеОрганыДействия Цикл
			Если Стр.Пометка Тогда
				СтруктураДанных.КодыНалоговыхОргановДействия.Добавить(Стр.Код);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Закрыть(СтруктураДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.НалоговыеОрганыДействия.Доступность = (Форма.ТипНалоговыхОргановДействия = "1");
	
КонецПроцедуры

&НаКлиенте
Функция СохранениеВозможно()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если ТипНалоговыхОргановДействия = "1" Тогда
		ЕстьНалоговыеОрганыДействия = Ложь;
		Для каждого Стр Из НалоговыеОрганыДействия Цикл
			Если Стр.Пометка Тогда
				ЕстьНалоговыеОрганыДействия = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не ЕстьНалоговыеОрганыДействия Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не выбраны налоговые органы, для которых действует доверенность.'"),,
				"НалоговыеОрганыДействия",, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

#КонецОбласти
