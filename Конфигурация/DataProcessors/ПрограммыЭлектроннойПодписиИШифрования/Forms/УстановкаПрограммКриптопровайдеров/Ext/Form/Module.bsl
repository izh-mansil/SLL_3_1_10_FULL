﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ВходящиеКонтексты;

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьVipNet(Команда)
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПовторнаяПроверкаПрограммКриптографии", ЭтотОбъект);
	
	ВходящийКонтекст = Неопределено;
	Если ТипЗнч(ВходящиеКонтексты) = Тип("Соответствие") Тогда
		ВходящийКонтекст = ВходящиеКонтексты.Получить(ЭлектроннаяПодписьКлиентСерверЛокализация.ИмяПрограммыVipNet());
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебныйКлиент.УстановитьVipNet(ЭтотОбъект, ОповещениеОЗавершении, ВходящийКонтекст);
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКриптоПро(Команда)
	
	ВходящийКонтекст = Неопределено;
	Если ТипЗнч(ВходящиеКонтексты) = Тип("Соответствие") Тогда
		ВходящийКонтекст = ВходящиеКонтексты.Получить(ЭлектроннаяПодписьКлиентСерверЛокализация.ИмяПрограммыКриптоПро());
	КонецЕсли;

	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПовторнаяПроверкаПрограммКриптографии", ЭтотОбъект);
	ЭлектроннаяПодписьСлужебныйКлиент.УстановитьКриптоПро(ЭтотОбъект, ОповещениеОЗавершении, ВходящийКонтекст);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьLISSI(Команда)
		
	ЭлектроннаяПодписьСлужебныйКлиент.УстановитьLISSI();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьSignalCOM(Команда)
	
	ЭлектроннаяПодписьСлужебныйКлиент.УстановитьSignalCOM();
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Асинх Процедура ПовторнаяПроверкаПрограммКриптографии(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ТипЗнч(Результат) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Выполнено = Истина Тогда
		
		ОбновитьПовторноИспользуемыеЗначения();
		
		Ответ = Ждать ВопросАсинх(
			НСтр("ru = 'Для работы с только что установленным криптопровайдером перезапустите сеанс. Перезапустить сейчас?'"),
			РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет, НСтр("ru = 'После установки криптопровайдера'"));

		Если Ответ = КодВозвратаДиалога.Да Тогда
			ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы", Истина);
			ЗавершитьРаботуСистемы(Истина, Истина);
			Возврат;
		КонецЕсли;
		
		Закрыть();
		Возврат;
		
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Результат, "ВходящийКонтекст", Неопределено) <> Неопределено Тогда
		Если ВходящиеКонтексты = Неопределено Тогда
			ВходящиеКонтексты = Новый Соответствие;
		КонецЕсли;
		ВходящиеКонтексты.Вставить(Результат.ВходящийКонтекст.ИмяПрограммы, Результат.ВходящийКонтекст);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат.ОписаниеОшибки) Тогда
		ПоказатьПредупреждение(, УстановитьГиперссылку(Результат.ОписаниеОшибки));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция УстановитьГиперссылку(Строка)
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Новый Структура("Текст, Гиперссылка", "www.infotecs.ru", "https://infotecs.ru/"));
	МассивСсылок.Добавить(Новый Структура("Текст, Гиперссылка", "www.cryptopro.ru", "https://cryptopro.ru/"));
	
	Для Каждого ТекущаяСсылка Из МассивСсылок Цикл
		Позиция = СтрНайти(Строка, ТекущаяСсылка.Текст);
		Если Позиция = 0 Тогда
			Продолжить;
		КонецЕсли;

		СтрокаСоСсылкой = Новый ФорматированнаяСтрока(ТекущаяСсылка.Текст, , , , ТекущаяСсылка.Гиперссылка);

		Возврат Новый ФорматированнаяСтрока(Лев(Строка, Позиция - 1), СтрокаСоСсылкой, Сред(Строка, Позиция + СтрДлина(
			ТекущаяСсылка.Текст)));
	КонецЦикла;
	
	Возврат Новый ФорматированнаяСтрока(Строка);
	
КонецФункции

#КонецОбласти