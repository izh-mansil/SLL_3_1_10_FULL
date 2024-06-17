﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДанныеАвторизации();
	
	Элементы.ГруппаНастройкиАвторизации1СФреш.Видимость = Не РаботаВМоделиСервиса.РазделениеВключено();	
	Элементы.НастройкиОплатыСервиса.Доступность = НаборКонстант.ИспользоватьОплатуСервиса;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не РаботаВМоделиСервиса.РазделениеВключено() Тогда
		ШаблонСообщения = НСтр("ru='Поле ""%1"" не заполнено.'");
		ПроверяемыеКонстанты = Новый Массив;
		ПроверяемыеКонстанты.Добавить("АдресСервиса1СФреш");
		Для Каждого Элемент Из ПроверяемыеКонстанты Цикл
			Если Не ЗначениеЗаполнено(Константы.АдресСервиса1СФреш.Получить()) Тогда
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(ШаблонСообщения, Метаданные.Константы[Элемент].Представление()), , Элемент, "НаборКонстант", Отказ);
			КонецЕсли;
		КонецЦикла; 
	КонецЕсли;
	ДанныеАвторизации = РегистрыСведений.АвторизацияВСервисе1СФреш.Прочитать(Пользователи.ТекущийПользователь());
	Если Не ЗначениеЗаполнено(ДанныеАвторизации.Логин) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Не установлены данные авторизации в сервисе.'"), , , , Отказ);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура АдресСервиса1СФрешПриИзменении(Элемент)
	
	ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьДанныеАвторизации(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПослеУстановкиДанныхАвторизации", ЭтотОбъект);
	
	ПараметрыФормы = Неопределено;
	Если АвторизацияУстановлена Тогда
		КонструкторКлюча = Новый Массив;
		КонструкторКлюча.Добавить(Новый Структура("Пользователь", ПользователиКлиент.ТекущийПользователь()));
		КлючЗаписи = Новый("РегистрСведенийКлючЗаписи.АвторизацияВСервисе1СФреш", КонструкторКлюча);
		ПараметрыФормы = Новый Структура("Ключ", КлючЗаписи);
	КонецЕсли;

	ОткрытьФорму("РегистрСведений.АвторизацияВСервисе1СФреш.ФормаЗаписи", ПараметрыФормы, , , , , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОплатыСервиса(Команда)
	
	ПараметрыФормы = Новый Структура;
	ОткрытьФорму(
		"Обработка.ПанельАдминистрированияБТС.Форма.НастройкиОплатыСервиса", ПараметрыФормы,ЭтотОбъект);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьТарифыСервиса(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли; 
	
	ДлительнаяОперация = НачатьЗагрузкуТарифовСервиса();
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	Оповещение = Новый ОписаниеОповещения("ПриЗавершенииЗагрузкиТарифов", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОплатуСервисаПриИзменении(Элемент)
	
	ПриИзмененииРеквизита(Элемент);
	Элементы.НастройкиОплатыСервиса.Доступность = НаборКонстант.ИспользоватьОплатуСервиса;
	ОбновитьИнтерфейс();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеУстановкиДанныхАвторизации(Результат, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьДанныеАвторизации();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеАвторизации()
	
	ДанныеАвторизации = РегистрыСведений.АвторизацияВСервисе1СФреш.Прочитать(Пользователи.ТекущийПользователь());
	Если Не ЗначениеЗаполнено(ДанныеАвторизации.Логин) Тогда
		Элементы.УстановитьДанныеАвторизации.Заголовок = НСтр("ru = 'Установить данные авторизации'")
	Иначе
		АвторизацияУстановлена = Истина;
		Элементы.УстановитьДанныеАвторизации.Заголовок = СтрШаблон(
			НСтр("ru = 'Логин: %1, код абонента: %2'"), ДанныеАвторизации.Логин, Формат(ДанныеАвторизации.КодАбонента, "ЧГ=0"));
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция НачатьЗагрузкуТарифовСервиса()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияПроцедуры();
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения, "ОплатаСервиса.ЗагрузитьТарифыСервиса");
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииЗагрузкиТарифов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда // Пользователь отменил задание.
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Загрузка выполнена'"), , 
		НСтр("ru = 'Загрузка тарифов сервиса выполнена.'"), БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРеквизита(Элемент)
	
	ИменаКонстант = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Для Каждого ИмяКонстанты Из ИменаКонстант Цикл
		Если ИмяКонстанты <> "" Тогда
			Оповестить("Запись_НаборКонстант", Новый Структура, ИмяКонстанты);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	ИменаКонстант = Новый Массив;
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	НачатьТранзакцию();
	Попытка
		
		ИмяКонстанты = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
		ИменаКонстант.Добавить(ИмяКонстанты);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	ОбновитьПовторноИспользуемыеЗначения();
	Возврат ИменаКонстант;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
	Если ЧастиИмени.Количество() <> 2 Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяКонстанты = ЧастиИмени[1];
	КонстантаМенеджер = Константы[ИмяКонстанты];
	КонстантаЗначение = НаборКонстант[ИмяКонстанты];
	ТекущееЗначение  = КонстантаМенеджер.Получить();
	Если ТекущееЗначение <> КонстантаЗначение Тогда
		Попытка
			КонстантаМенеджер.Установить(КонстантаЗначение);
		Исключение
			НаборКонстант[ИмяКонстанты] = ТекущееЗначение;
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
	Возврат ИмяКонстанты;
	
КонецФункции

#КонецОбласти
