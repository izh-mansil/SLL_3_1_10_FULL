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

// Задать настройки формы отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//         - Неопределено
//   КлючВарианта - Строка
//                - Неопределено
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения СКД отчета.
//
// Параметры:
//   Контекст - Произвольный
//   КлючСхемы - Строка
//   КлючВарианта - Строка
//                - Неопределено
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных
//                    - Неопределено
//   НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных
//                                    - Неопределено
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючСхемы <> "1" Тогда
		КлючСхемы = "1";
		
		Если ТипЗнч(Контекст) = Тип("ФормаКлиентскогоПриложения")
		   И НовыеНастройкиКД <> Неопределено
		   И Контекст.Параметры.Свойство("ПараметрКоманды")
		   И ЗначениеЗаполнено(Контекст.Параметры.ПараметрКоманды) Тогда
			
			Значения = Контекст.Параметры.ПараметрКоманды;
			Если ТипЗнч(Значения[0]) = Тип("СправочникСсылка.Пользователи") Тогда
				ИмяПараметра = "Пользователь";
			ИначеЕсли ТипЗнч(Значения[0]) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
				ИмяПараметра = "ГруппаПользователей";
			ИначеЕсли ТипЗнч(Значения[0]) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
				ИмяПараметра = "ВнешнийПользователь";
			ИначеЕсли ТипЗнч(Значения[0]) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда
				ИмяПараметра = "ГруппаВнешнихПользователей";
			КонецЕсли;
			
			СписокЗначений = Новый СписокЗначений;
			СписокЗначений.ЗагрузитьЗначения(Значения);
			ПользователиСлужебный.УстановитьОтборДляПараметра(ИмяПараметра,
				СписокЗначений, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
		КонецЕсли;
	КонецЕсли;
	
	Если КлючВарианта = "ИзменениеУчастниковГруппВнешнихПользователей" Тогда
		СхемаКомпоновкиДанных.Параметры.Пользователь.ОграничениеИспользования = Истина;
		СхемаКомпоновкиДанных.Параметры.ГруппаПользователей.ОграничениеИспользования = Истина;
	Иначе
		СхемаКомпоновкиДанных.Параметры.ВнешнийПользователь.ОграничениеИспользования = Истина;
		СхемаКомпоновкиДанных.Параметры.ГруппаВнешнихПользователей.ОграничениеИспользования = Истина;
	КонецЕсли;
	
	МодульОтчетыСервер = ОбщегоНазначения.ОбщийМодуль("ОтчетыСервер");
	МодульОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ВыполнитьПроверкуПравДоступа("АдминистрированиеДанных", Метаданные);
	Иначе
		ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	КонецЕсли;
	УстановитьПривилегированныйРежим(Истина);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("Изменения", ИзмененияСоставов(Настройки));
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.НачатьВывод();
	ЭлементРезультата = ПроцессорКомпоновки.Следующий();
	Пока ЭлементРезультата <> Неопределено Цикл
		ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();
	КонецЦикла;
	ПроцессорВывода.ЗакончитьВывод();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоВариантДляВнешнихПользователей()
	
	Свойства = Новый Структура("КлючПредопределенногоВарианта");
	ЗаполнитьЗначенияСвойств(Свойства, КомпоновщикНастроек.Настройки.ДополнительныеСвойства);
	
	Возврат Свойства.КлючПредопределенногоВарианта = "ИзменениеУчастниковГруппВнешнихПользователей";
	
КонецФункции

Функция ИзмененияСоставов(Настройки)
	
	Отбор = Новый Структура;
	
	СтатусыТранзакции = Новый Массив;
	СтатусыТранзакции.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.Зафиксирована);
	СтатусыТранзакции.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.НетТранзакции);
	Отбор.Вставить("СтатусТранзакции", СтатусыТранзакции);
	
	Период = ЗначениеПараметра(Настройки, "Период", Новый СтандартныйПериод);
	Если ЗначениеЗаполнено(Период.ДатаНачала) Тогда
		Отбор.Вставить("StartDate", Период.ДатаНачала);
	КонецЕсли;
	Если ЗначениеЗаполнено(Период.ДатаОкончания) Тогда
		Отбор.Вставить("EndDate", Период.ДатаОкончания);
	КонецЕсли;
	
	Если ЭтоВариантДляВнешнихПользователей() Тогда
		ИмяПараметраПользователь = "ВнешнийПользователь";
		ИмяПараметраГруппаПользователей = "ГруппаВнешнихПользователей";
		Отбор.Вставить("Событие",
			ПользователиСлужебный.ИмяСобытияИзменениеИзменениеУчастниковГруппВнешнихПользователейДляЖурналаРегистрации());
	Иначе
		ИмяПараметраПользователь = "Пользователь";
		ИмяПараметраГруппаПользователей = "ГруппаПользователей";
		Отбор.Вставить("Событие",
			ПользователиСлужебный.ИмяСобытияИзменениеИзменениеУчастниковГруппПользователейДляЖурналаРегистрации());
	КонецЕсли;
	
	Автор = ЗначениеПараметра(Настройки, "Автор", Null);
	Если Автор <> Null Тогда
		Отбор.Вставить("Пользователь", Строка(Автор));
	КонецЕсли;
	
	ТипБулево     = Новый ОписаниеТипов("Булево");
	ТипДата       = Новый ОписаниеТипов("Дата");
	ТипЧисло      = Новый ОписаниеТипов("Число");
	ТипСтрока     = Новый ОписаниеТипов("Строка");
	ТипСтрока1    = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1));
	ТипСтрока20   = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(20));
	ТипСтрока36   = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(36));
	ТипСтрока73   = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(73));
	ТипСтрока100  = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(100));
	ТипСтрока1024 = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1024));
	
	Изменения = Новый ТаблицаЗначений;
	Колонки = Изменения.Колонки;
	Колонки.Добавить("ИдентификаторРодителя",     ТипСтрока73);
	Колонки.Добавить("ИдентификаторСтроки",       ТипСтрока73);
	Колонки.Добавить("ПредставлениеСтроки",       ТипСтрока);
	Колонки.Добавить("ЭтоСобытие",                ТипБулево);
	Колонки.Добавить("ЭтоГруппа",                 ТипБулево);
	Колонки.Добавить("ЭтоПользователь",           ТипБулево);
	Колонки.Добавить("НомерСобытия",              ТипЧисло);
	Колонки.Добавить("Дата",                      ТипДата);
	Колонки.Добавить("Автор",                     ТипСтрока100);
	Колонки.Добавить("ИдентификаторАвтора",       ТипСтрока36);
	Колонки.Добавить("Приложение",                ТипСтрока20);
	Колонки.Добавить("Компьютер",                 ТипСтрока);
	Колонки.Добавить("Сеанс",                     ТипЧисло);
	Колонки.Добавить("Соединение",                ТипЧисло);
	Колонки.Добавить("ИдентификаторГруппы",       ТипСтрока36);
	Колонки.Добавить("ИдентификаторПользователя", ТипСтрока36);
	Колонки.Добавить("ИзНижестоящейГруппы",       ТипБулево);
	Колонки.Добавить("Используется",              ТипБулево);
	Колонки.Добавить("ВидИзменения",              ТипСтрока1);
	Колонки.Добавить("ПредставлениеГруппы",       ТипСтрока1024);
	Колонки.Добавить("ПредставлениеПользователя", ТипСтрока1024);
	
	КолонкиЖурнала = "Дата,Пользователь,ИмяПользователя,
	|ИмяПриложения,Компьютер,Сеанс,Соединение,Данные";
	
	УстановитьПривилегированныйРежим(Истина);
	События = Новый ТаблицаЗначений;
	ВыгрузитьЖурналРегистрации(События, Отбор, КолонкиЖурнала);
	
	НомерСобытия = 0;
	ОтборДанных = Новый Структура;
	ОтборДанных.Вставить("Пользователи", ИдентификаторыЗначений(
		ЗначениеПараметра(Настройки, ИмяПараметраПользователь, Неопределено)));
	ОтборДанных.Вставить("ГруппыПользователей", ИдентификаторыЗначений(
		ЗначениеПараметра(Настройки, ИмяПараметраГруппаПользователей, Неопределено)));
	ОтборДанных.Вставить("СкрыватьПользователейНижестоящихГрупп",
		ЗначениеПараметра(Настройки, "СкрыватьПользователейНижестоящихГрупп", Ложь));
	
	Для Каждого Событие Из События Цикл
		Данные = РасширенныеДанныеИзменения(Событие.Данные, ОтборДанных);
		Если Данные = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ИдентификаторСобытия = НРег(Новый УникальныйИдентификатор);
		НомерСобытия = НомерСобытия + 1;
		ПредставлениеСтроки = Новый Массив;
		ПредставлениеСтроки.Добавить(Событие.Дата);
		ПредставлениеСтроки.Добавить(Событие.ИмяПользователя);
		ПредставлениеСтроки.Добавить(Событие.ИмяПриложения);
		ПредставлениеСтроки.Добавить(Событие.Компьютер);
		ПредставлениеСтроки.Добавить(Событие.Сеанс);
		
		НоваяСтрока = Изменения.Добавить();
		НоваяСтрока.НомерСобытия        = НомерСобытия;
		НоваяСтрока.ЭтоСобытие          = Истина;
		НоваяСтрока.ИдентификаторСтроки = ИдентификаторСобытия;
		НоваяСтрока.ПредставлениеСтроки = СтрСоединить(ПредставлениеСтроки,  ", ");
		НоваяСтрока.Дата                = Событие.Дата;
		НоваяСтрока.Автор               = Событие.ИмяПользователя;
		НоваяСтрока.ИдентификаторАвтора = Событие.Пользователь;
		НоваяСтрока.Приложение          = Событие.ИмяПриложения;
		НоваяСтрока.Компьютер           = Событие.Компьютер;
		НоваяСтрока.Сеанс               = Событие.Сеанс;
		НоваяСтрока.Соединение          = Событие.Соединение;
		
		Префикс = ИдентификаторСобытия + "_";
		
		Для Каждого Строка Из Данные.ПредставлениеГрупп Цикл
			НоваяСтрока = Изменения.Добавить();
			НоваяСтрока.НомерСобытия          = НомерСобытия;
			НоваяСтрока.ЭтоГруппа             = Истина;
			НоваяСтрока.ИдентификаторСтроки   = Префикс + Строка.ИдентификаторГруппы;
			НоваяСтрока.ИдентификаторРодителя = ?(ЗначениеЗаполнено(Строка.ИдентификаторРодителя),
				Префикс + Строка.ИдентификаторРодителя, ИдентификаторСобытия);
			НоваяСтрока.ПредставлениеСтроки   = Строка.ПредставлениеГруппы;
			
			НоваяСтрока.ИдентификаторГруппы = Строка.ИдентификаторГруппы;
			НоваяСтрока.ПредставлениеГруппы = Строка.ПредставлениеГруппы;
		КонецЦикла;
		
		Для Каждого Строка Из Данные.ИзмененияСоставов Цикл
			НоваяСтрока = Изменения.Добавить();
			НоваяСтрока.НомерСобытия          = НомерСобытия;
			НоваяСтрока.ЭтоПользователь       = Истина;
			НоваяСтрока.ИдентификаторСтроки   = Префикс + Строка.ИдентификаторПользователя;
			НоваяСтрока.ИдентификаторРодителя = Префикс + Строка.ИдентификаторГруппы;
			
			НоваяСтрока.ИдентификаторПользователя = Строка.ИдентификаторПользователя;
			НоваяСтрока.ИзНижестоящейГруппы       = Строка.ИзНижестоящейГруппы;
			НоваяСтрока.Используется              = Строка.Используется;
			НоваяСтрока.ВидИзменения = ?(Строка.ВидИзменения = "Удален", "-",
				?(Строка.ВидИзменения = "Добавлен", "+", ?(Строка.ВидИзменения = "ИспользованиеИзменено", "*", "?")));
			
			НайденнаяСтрока = Данные.ПредставлениеПользователей.Найти(
				Строка.ИдентификаторПользователя, "ИдентификаторПользователя");
			НоваяСтрока.ПредставлениеПользователя = ?(НайденнаяСтрока <> Неопределено,
				НайденнаяСтрока.ПредставлениеПользователя, Строка.ИдентификаторПользователя);
			
			НоваяСтрока.ПредставлениеСтроки = НоваяСтрока.ВидИзменения + " "
				+ НоваяСтрока.ПредставлениеПользователя;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Изменения;
	
КонецФункции

Функция ЗначениеПараметра(Настройки, ИмяПараметра, ЗначениеПоУмолчанию)
	
	Поле = Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	
	Если Поле <> Неопределено И Поле.Использование Тогда
		Возврат Поле.Значение;
	КонецЕсли;
	
	Возврат ЗначениеПоУмолчанию;
	
КонецФункции

Функция ИдентификаторыЗначений(ВыбранныеЗначения)
	
	Если ВыбранныеЗначения = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(ВыбранныеЗначения) = Тип("СписокЗначений") Тогда
		Значения = ВыбранныеЗначения.ВыгрузитьЗначения();
	Иначе
		Значения = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранныеЗначения);
	КонецЕсли;
	
	Результат = Новый Соответствие;
	
	Для Каждого Значение Из Значения Цикл
		Если Не ЗначениеЗаполнено(Значение) Тогда
			Продолжить;
		КонецЕсли;
		Результат.Вставить(НРег(Значение.УникальныйИдентификатор()), Истина);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Параметры:
//  ДанныеСобытия - Строка
//
// Возвращаемое значение:
//  Структура:
//   * Ссылка - СправочникСсылка.Пользователи
//            - СправочникСсылка.ВнешниеПользователи
//   * Имя    - Строка
//   * УникальныйИдентификатор - Строка - уникальный идентификатор в нижнем регистре.
//   * Недействителен - Булево
//   * ПометкаУдаления - Булево
//   * ПотребоватьСменуПароляПриВходе - Булево
//   * СрокДействияНеОграничен - Булево
//   * СрокДействия - Дата
//   * ПросрочкаРаботыВПрограммеДоЗапрещенияВхода - Число
//
Функция РасширенныеДанныеИзменения(ДанныеСобытия, ОтборДанных)
	
	Если Не ЗначениеЗаполнено(ДанныеСобытия) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		Данные = ОбщегоНазначения.ЗначениеИзСтрокиXML(ДанныеСобытия);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Если ТипЗнч(Данные) <> Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Хранение = Новый Структура;
	Хранение.Вставить("ВерсияСтруктурыДанных");
	Хранение.Вставить("ИзмененияСоставов");
	Хранение.Вставить("ПредставлениеГрупп");
	Хранение.Вставить("ПредставлениеПользователей");
	ЗаполнитьЗначенияСвойств(Хранение, Данные);
	Если Хранение.ВерсияСтруктурыДанных <> 1 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Свойства = Новый Структура;
	Свойства.Вставить("ИдентификаторГруппы", "");
	Свойства.Вставить("ИдентификаторПользователя", "");
	Свойства.Вставить("ИзНижестоящейГруппы", Ложь);
	Свойства.Вставить("Используется", Ложь);
	Свойства.Вставить("ВидИзменения", "");
	
	ИзмененияСоставов = ХранимаяТаблица(Хранение.ИзмененияСоставов, Свойства);
	Если Не ЗначениеЗаполнено(ИзмененияСоставов) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Свойства = Новый Структура;
	Свойства.Вставить("ИдентификаторРодителя", "");
	Свойства.Вставить("ИдентификаторГруппы", "");
	Свойства.Вставить("ПредставлениеГруппы", "");
	
	ПредставлениеГрупп = ХранимаяТаблица(Хранение.ПредставлениеГрупп, Свойства);
	Если ПредставлениеГрупп = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Свойства = Новый Структура;
	Свойства.Вставить("ИдентификаторРодителя", "");
	Свойства.Вставить("ИдентификаторГруппы", "");
	Свойства.Вставить("ПредставлениеГруппы", "");
	
	ПредставлениеГрупп = ХранимаяТаблица(Хранение.ПредставлениеГрупп, Свойства);
	Если ПредставлениеГрупп = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Свойства = Новый Структура;
	Свойства.Вставить("ИдентификаторПользователя", "");
	Свойства.Вставить("ПредставлениеПользователя", "");
	
	ПредставлениеПользователей = ХранимаяТаблица(Хранение.ПредставлениеПользователей, Свойства);
	Если ПредставлениеПользователей = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ИзмененияСоставов", ИзмененияСоставов);
	Результат.Вставить("ПредставлениеГрупп", ПредставлениеГрупп);
	Результат.Вставить("ПредставлениеПользователей", ПредставлениеПользователей);
	
	Если ОтборДанных.Пользователи = Неопределено
	   И ОтборДанных.ГруппыПользователей = Неопределено
	   И ОтборДанных.СкрыватьПользователейНижестоящихГрупп <> Истина Тогда
		
		Возврат Результат;
	КонецЕсли;
	
	ИспользуемыеГруппы = Новый Соответствие;
	РодителиГрупп = Новый Соответствие;
	Индекс = ИзмененияСоставов.Количество();
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		Строка = ИзмененияСоставов.Получить(Индекс);
		Если ОтборДанных.Пользователи <> Неопределено
		   И ОтборДанных.Пользователи.Получить(Строка.ИдентификаторПользователя) = Неопределено
		 Или ОтборДанных.СкрыватьПользователейНижестоящихГрупп = Истина
		   И Строка.ИзНижестоящейГруппы Тогда
			ИзмененияСоставов.Удалить(Индекс);
			Продолжить;
		КонецЕсли;
		РодителиГруппы = РодителиГрупп.Получить(Строка.ИдентификаторГруппы);
		Если РодителиГруппы = Неопределено Тогда
			РодителиГруппы = Новый Соответствие;
			ТекущаяГруппа = Строка.ИдентификаторГруппы;
			Пока Истина Цикл
				НайденнаяСтрока = ПредставлениеГрупп.Найти(ТекущаяГруппа, "ИдентификаторГруппы");
				Если НайденнаяСтрока = Неопределено Тогда
					Прервать;
				КонецЕсли;
				Если РодителиГруппы.Получить(НайденнаяСтрока.ИдентификаторГруппы) <> Неопределено Тогда
					Прервать;
				КонецЕсли;
				РодителиГруппы.Вставить(ТекущаяГруппа, Истина);
				Если Не ЗначениеЗаполнено(НайденнаяСтрока.ИдентификаторРодителя) Тогда
					Прервать;
				КонецЕсли;
				ТекущаяГруппа = НайденнаяСтрока.ИдентификаторРодителя;
			КонецЦикла;
		КонецЕсли;
		Если ОтборДанных.ГруппыПользователей <> Неопределено Тогда
			ГруппаНайдена = Ложь;
			Для Каждого КлючИЗначение Из РодителиГруппы Цикл
				Если ОтборДанных.ГруппыПользователей.Получить(КлючИЗначение.Ключ) <> Неопределено Тогда
					ГруппаНайдена = Истина;
				КонецЕсли;
			КонецЦикла;
			Если Не ГруппаНайдена Тогда
				ИзмененияСоставов.Удалить(Индекс);
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		Для Каждого КлючИЗначение Из РодителиГруппы Цикл
			ИспользуемыеГруппы.Вставить(КлючИЗначение.Ключ, Истина);
		КонецЦикла;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИзмененияСоставов) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Индекс = ПредставлениеГрупп.Количество();
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		Строка = ПредставлениеГрупп.Получить(Индекс);
		Если ИспользуемыеГруппы.Получить(Строка.ИдентификаторГруппы) = Неопределено Тогда
			ПредставлениеГрупп.Удалить(Индекс);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ХранимаяТаблица(Строки, Свойства)
	
	Если ТипЗнч(Строки) <> Тип("Массив") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый ТаблицаЗначений;
	Для Каждого КлючИЗначение Из Свойства Цикл
		Типы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(КлючИЗначение.Значение));
		Результат.Колонки.Добавить(КлючИЗначение.Ключ, Новый ОписаниеТипов(Типы));
	КонецЦикла;
	
	Для Каждого Строка Из Строки Цикл
		Если ТипЗнч(Строка) <> Тип("Структура") Тогда
			Возврат Неопределено;
		КонецЕсли;
		НоваяСтрока = Результат.Добавить();
		Для Каждого КлючИЗначение Из Свойства Цикл
			Если Не Строка.Свойство(КлючИЗначение.Ключ)
			 Или ТипЗнч(Строка[КлючИЗначение.Ключ]) <> ТипЗнч(КлючИЗначение.Значение) Тогда
				Возврат Неопределено;
			КонецЕсли;
			НоваяСтрока[КлючИЗначение.Ключ] = Строка[КлючИЗначение.Ключ];
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли