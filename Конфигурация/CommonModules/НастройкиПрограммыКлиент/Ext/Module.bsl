﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Вызывается из обработчика ПриОткрытии() панели администрирования БСП и БИП. Выполняет настройку отображения элементов
// управления для подсистем библиотеки БСП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Отказ - Булево
//
Процедура ИнтернетПоддержкаИСервисыПриОткрытии(Форма, Отказ) Экспорт
	
	// Обновление состояния элементов.
	ИнтернетПоддержкаИСервисыУстановитьДоступность(Форма);
	
	ИнтернетПоддержкаИСервисыПриИзмененииСостоянияПодключенияОбсуждений(Форма);
	
КонецПроцедуры

// Вызывается из обработчика ОбработкаОповещения() панели администрирования БСП и БИП. Выполняет настройку отображения
// элементов управления для подсистем библиотеки БСП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  ИмяСобытия - Строка - имя события для идентификации сообщений.
//  Параметр - Произвольный - параметр события.
//  Источник - Произвольный - источник события.
//
Процедура ИнтернетПоддержкаИСервисыОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "ОбсужденияПодключены" Тогда
		ИнтернетПоддержкаИСервисыПриИзмененииСостоянияПодключенияОбсуждений(Форма, Параметр);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку события ПриИзменении() элементов формы БСП ЦентрМониторингаРазрешитьОтправлятьДанные,
// ЦентрМониторингаРазрешитьОтправлятьДанныеСтороннему, ЦентрМониторингаЗапретитьОтправлятьДанные панели
// администрирования "Интернет-поддержка и сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Элемент - ПолеФормы
//  ПараметрыОперации - Структура:
//    * РезультатЗапуска - см. ДлительныеОперации.ВыполнитьВФоне
//
Процедура ИнтернетПоддержкаИСервисыРазрешитьОтправлятьДанныеПриИзменении(Форма, Элемент, ПараметрыОперации) Экспорт

	Если ПараметрыОперации.РезультатЗапуска <> Неопределено Тогда
		Форма.ЦентрМониторингаИдентификаторЗадания = ПараметрыОперации.РезультатЗапуска.ИдентификаторЗадания;
		Форма.ЦентрМониторингаАдресРезультатаЗадания = ПараметрыОперации.РезультатЗапуска.АдресРезультата;
		МодульЦентрМониторингаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЦентрМониторингаКлиент");
		Оповещение = Новый ОписаниеОповещения("ПослеОбновленияИдентификатора", МодульЦентрМониторингаКлиент);
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ПараметрыОперации.РезультатЗапуска, Оповещение, ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку события ПриИзменении() элементов формы БСП, связанного с константой панели администрирования
// "Интернет-поддержка и сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Элемент - ПолеФормы
//
Процедура ИнтернетПоддержкаИСервисыПриИзмененииКонстанты(Форма, Элемент) Экспорт
	
	ИмяКонстанты = Элемент.Имя;
	
	ИнтернетПоддержкаИСервисыУстановитьДоступность(Форма, ИмяКонстанты);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ИмяКонстанты <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, ИмяКонстанты);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку события команды БСП ЗагрузкаАдресногоКлассификатора панели администрирования "Интернет-поддержка
// и сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Команда - КомандаФормы
//
Процедура ИнтернетПоддержкаИСервисыЗагрузкаАдресногоКлассификатора(Форма, Команда) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
		МодульАдресныйКлассификаторКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("АдресныйКлассификаторКлиент");
		МодульАдресныйКлассификаторКлиент.ЗагрузитьАдресныйКлассификатор();
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку события команды БСП ОчисткаАдресныхСведений панели администрирования "Интернет-поддержка и
// сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Команда - КомандаФормы
//
Процедура ИнтернетПоддержкаИСервисыОчисткаАдресныхСведений(Форма, Команда) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
		МодульАдресныйКлассификаторКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("АдресныйКлассификаторКлиент");
		МодульАдресныйКлассификаторКлиент.ПоказатьОчисткуАдресногоКлассификатора();
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку события команды БСП ЗагрузкаКурсовВалют панели администрирования "Интернет-поддержка и сервисы"
// БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Команда - КомандаФормы
//
Процедура ИнтернетПоддержкаИСервисыЗагрузкаКурсовВалют(Форма, Команда) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты") Тогда
		МодульРаботаСКурсамиВалютКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСКурсамиВалютКлиент");
		МодульРаботаСКурсамиВалютКлиент.ПоказатьЗагрузкуКурсовВалют();
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку события команды БСП ОткрытьОписаниеИзмененийСистемы панели администрирования "Интернет-поддержка
// и сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Команда - КомандаФормы
//
Процедура ИнтернетПоддержкаИСервисыОткрытьОписаниеИзмененийСистемы(Форма, Команда) Экспорт
	
	ОткрытьФорму("ОбщаяФорма.ОписаниеИзмененийПрограммы",, Форма);
	
КонецПроцедуры

// Выполняет обработку события команды БСП НастройкаДоступаКСервисуMorpher панели администрирования "Интернет-поддержка
// и сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Команда - КомандаФормы
//
Процедура ИнтернетПоддержкаИСервисыНастройкаДоступаКСервисуMorpher(Форма, Команда) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.СклонениеПредставленийОбъектов") Тогда
		МодульСклонениеПредставленийОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"СклонениеПредставленийОбъектовКлиент");
		МодульСклонениеПредставленийОбъектовКлиент.ПоказатьНастройкиДоступаКСервисуMorpher();
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку события команды БСП ЦентрМониторингаНастройки панели администрирования "Интернет-поддержка и
// сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Команда - КомандаФормы
//
Процедура ИнтернетПоддержкаИСервисыЦентрМониторингаНастройки(Форма, Команда) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ИдентификаторЗадания"  , Форма.ЦентрМониторингаИдентификаторЗадания);
		ПараметрыОткрытия.Вставить("АдресРезультатаЗадания", Форма.ЦентрМониторингаАдресРезультатаЗадания);
		МодульЦентрМониторингаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЦентрМониторингаКлиент");
		МодульЦентрМониторингаКлиент.ПоказатьНастройкиЦентраМониторинга(Форма, ПараметрыОткрытия);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку события команды БСП ЦентрМониторингаОтправитьКонтактнуюИнформацию панели администрирования
// "Интернет-поддержка и сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Команда - КомандаФормы
//
Процедура ИнтернетПоддержкаИСервисыЦентрМониторингаОтправитьКонтактнуюИнформацию(Форма, Команда) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
		МодульЦентрМониторингаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЦентрМониторингаКлиент");
		МодульЦентрМониторингаКлиент.ПоказатьНастройкуОтправкиКонтактнойИнформации(Форма);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку события команды БСП ОткрытьВнешниеКомпоненты панели администрирования "Интернет-поддержка и
// сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Команда - КомандаФормы
//
Процедура ИнтернетПоддержкаИСервисыОткрытьВнешниеКомпоненты(Форма, Команда) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ВнешниеКомпоненты") Тогда
		МодульВнешниеКомпонентыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВнешниеКомпонентыКлиент");
		МодульВнешниеКомпонентыКлиент.ПоказатьВнешниеКомпоненты();
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку события команды БСП РезультатыОбновленияИДополнительнаяОбработкаДанных панели администрирования
// "Интернет-поддержка и сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Команда - КомандаФормы
//
Процедура ИнтернетПоддержкаИСервисыОткрытьИндикациюХодаОтложенногоОбновленияИБ(Форма, Команда) Экспорт
	
	ПараметрыФормы = Новый Структура("ОткрытиеИзПанелиАдминистрирования", Истина);
	ОткрытьФорму(
		"Обработка.РезультатыОбновленияПрограммы.Форма.РезультатыОбновленияПрограммы",
		ПараметрыФормы);
	
КонецПроцедуры

// Выполняет обработку события команды БСП ПодключитьОтключитьОбсуждения панели администрирования "Интернет-поддержка и
// сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Команда - КомандаФормы
//
Процедура ИнтернетПоддержкаИСервисыПодключитьОтключитьОбсуждения(Форма, Команда) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Обсуждения") Тогда
		
		МодульОбсужденияСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбсужденияСлужебныйКлиент");
		
		Если МодульОбсужденияСлужебныйКлиент.Подключены() Тогда
			МодульОбсужденияСлужебныйКлиент.ПоказатьОтключение();
		Иначе
			МодульОбсужденияСлужебныйКлиент.ПоказатьПодключение();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку события команды БСП ОбсужденияНастроитьИнтеграциюСВнешнимиСистемами панели администрирования
// "Интернет-поддержка и сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Команда - КомандаФормы
//
Процедура ИнтернетПоддержкаИСервисыПоказатьНастройкуИнтеграцииСВнешнимиСистемами(Форма, Команда) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Обсуждения") Тогда
		МодульОбсужденияСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбсужденияСлужебныйКлиент");
		МодульОбсужденияСлужебныйКлиент.ПоказатьНастройкуИнтеграцииСВнешнимиСистемами();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОткрытьОбщиеНастройки() Экспорт
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБСП.Форма.ОбщиеНастройки");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнтернетПоддержкаИСервисыПриИзмененииСостоянияПодключенияОбсуждений(
	Форма,
	ОбсужденияПодключены = Неопределено)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Обсуждения") Тогда
		
		Элементы = Форма.Элементы;
		
		Если ОбсужденияПодключены = Неопределено Тогда
			МодульОбсужденияСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбсужденияСлужебныйКлиент");
			ОбсужденияПодключены = МодульОбсужденияСлужебныйКлиент.Подключены();
			Форма.ОбсужденияПодключены = ОбсужденияПодключены;
		КонецЕсли;
		
		Если ОбсужденияПодключены Тогда
			Элементы.ПодключитьОтключитьОбсуждения.Заголовок = НСтр("ru = 'Отключить'");
			Элементы.СостояниеПодключенияОбсуждений.Заголовок = НСтр("ru = 'Обсуждения подключены.'");
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
				"ОбсужденияНастроитьИнтеграциюСВнешнимиСистемами",
				"Доступность",
				Истина);
		Иначе
			Элементы.ПодключитьОтключитьОбсуждения.Заголовок = НСтр("ru = 'Подключить'");
			Элементы.СостояниеПодключенияОбсуждений.Заголовок = НСтр("ru = 'Подключение обсуждений не выполнено.'");
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
				"ОбсужденияНастроитьИнтеграциюСВнешнимиСистемами",
				"Доступность",
				Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обновляет доступность элементов панели администрирования "Интернет-поддержка и сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  ИмяКонстанты - Строка - если заполнено, то выполняется обновление элементов связанных с командой.
//
Процедура ИнтернетПоддержкаИСервисыУстановитьДоступность(Форма, ИмяКонстанты = "")
	
	Если Не Форма.ЭтоАдминистраторСистемы Тогда
		Возврат;
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	
	Если (ИмяКонстанты = "ИспользоватьСервисСклоненияMorpher" Или ИмяКонстанты = "")
		И ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.СклонениеПредставленийОбъектов") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ГруппаНастройкаСклонения",
			"Доступность",
			Форма.ИспользоватьСервисСклоненияMorpher);
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти