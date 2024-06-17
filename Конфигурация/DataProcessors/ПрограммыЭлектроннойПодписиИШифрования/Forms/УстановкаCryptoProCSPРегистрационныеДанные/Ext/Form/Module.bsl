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
	
	Продукт = "csp40";
	ЗаполнитьРегистрационныеДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОпределитьПродукт();
	
	Если ЗначениеЗаполнено(КонтактноеЛицо) И ЗначениеЗаполнено(ЭлектроннаяПочта) Тогда
		ТекущийЭлемент = Элементы.СерийныйНомер;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ЭлектроннаяПочта)
		И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ЭлектроннаяПочта) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректно заполнен адрес электронной почты.'"),, "ЭлектроннаяПочта",, Отказ);
	КонецЕсли;
	
	СимволыСерийногоНомера = Новый Массив;
	Если ЗначениеЗаполнено(СерийныйНомер) Тогда
		Для Индекс = 1 По СтрДлина(СерийныйНомер) Цикл
			ТекущийСимвол = ВРег(Сред(СерийныйНомер, Индекс, 1));
			Код = КодСимвола(ТекущийСимвол);
			Если (Код > 64 И Код < 91) ИЛИ (Код > 47 И Код < 58) Тогда
				СимволыСерийногоНомера.Добавить(ТекущийСимвол);
			КонецЕсли;
		КонецЦикла;
		
		ЧистыйСерийныйНомер = СтрСоединить(СимволыСерийногоНомера, "");
		Если СтрДлина(ЧистыйСерийныйНомер) <> 25 Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Некорректно заполнен серийный номер.'"),, "СерийныйНомер",, Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СерийныйНомерПриИзменении(Элемент)
	
	СерийныйНомер = СокрЛП(СерийныйНомер);
	ОпределитьПродукт();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ПараметрыРегистрации = Новый Структура;
		ПараметрыРегистрации.Вставить("КонтактноеЛицо", СокрЛП(КонтактноеЛицо));
		ПараметрыРегистрации.Вставить("ЭлектроннаяПочта", СокрЛП(ЭлектроннаяПочта));
		ПараметрыРегистрации.Вставить("СерийныйНомер", СокрЛП(СерийныйНомер));
		ПараметрыРегистрации.Вставить("Продукт", Продукт);
		ПараметрыРегистрации.Вставить("ВыполнятьКонтрольЦелостности", ВыполнятьКонтрольЦелостности);
		ПараметрыРегистрации.Вставить("ИмяПрограммы", ЭлектроннаяПодписьКлиентСерверЛокализация.ИмяПрограммыКриптоПро());
		
		Если Не ЗначениеЗаполнено(СерийныйНомер) Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Без указания серийного номера программа %1 будет работать ограниченное время.
                                 |
                                 |Продолжить?'"), ПараметрыРегистрации.ИмяПрограммы);
			Оповещение = Новый ОписаниеОповещения("ЗагрузитьПослеОтветаНаВопрос", ЭтотОбъект, ПараметрыРегистрации);
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
		Иначе
			ЗагрузитьПослеОтветаНаВопрос(КодВозвратаДиалога.Да, ПараметрыРегистрации);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьПослеОтветаНаВопрос(Ответ, ВходящийКонтекст) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		Закрыть(ВходящийКонтекст);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРегистрационныеДанные()

	ТекущийПользователь = Пользователи.ТекущийПользователь();
	КонтактноеЛицо = ТекущийПользователь;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");

		КонтактнаяИнформация = МодульУправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ТекущийПользователь,
			"АдресЭлектроннойПочты", ТекущаяДатаСеанса(), Ложь);
		Если КонтактнаяИнформация.Количество() > 0 И ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(
			КонтактнаяИнформация[0].Представление) Тогда
			ЭлектроннаяПочта = КонтактнаяИнформация[0].Представление;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьПродукт()
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	Если СтрНачинаетсяС(СерийныйНомер, "40")
		Или СтрНайти(СистемнаяИнформация.ВерсияОС, "Windows Vista") <> 0
		Или СтрНайти(СистемнаяИнформация.ВерсияОС, "Windows XP") <> 0
		Или СтрНайти(СистемнаяИнформация.ВерсияОС, "Windows 2000") <> 0 Тогда
		Продукт = "csp40";
	Иначе
		Продукт = "csp50r2_win";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

