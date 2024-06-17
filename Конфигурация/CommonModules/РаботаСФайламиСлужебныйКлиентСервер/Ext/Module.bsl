﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Получить уникальное имя файла в рабочем каталоге.
// Если есть совпадения, будет имя подобное "A1\Приказ.doc".
//
Функция УникальноеИмяСПутем(Знач ИмяКаталога, Знач ИмяФайла) Экспорт
	
	ОбщегоНазначенияКлиентСервер.Проверить(ЗначениеЗаполнено(ИмяКаталога),
		НСтр("ru='Каталог должен быть заполнен.'"),	"РаботаСФайламиСлужебныйКлиентСервер.УникальноеИмяСПутем");
	
	ИтоговыйПуть = "";
	
	Счетчик = 0;
	ЦиклНомер = 0;
	Успешно = Ложь;
	КодПервойБуквы = КодСимвола("A", 1);
	
	ГенераторСлучая = Неопределено;
	
#Если Не ВебКлиент Тогда
	ГенераторСлучая = Новый ГенераторСлучайныхЧисел(ТекущаяУниверсальнаяДатаВМиллисекундах());
#КонецЕсли

	КоличествоСлучайныхВариантов = 26;
	
	Пока НЕ Успешно И ЦиклНомер < 100 Цикл
		НомерКаталога = 0;
		
#Если Не ВебКлиент Тогда
		НомерКаталога = ГенераторСлучая.СлучайноеЧисло(0, КоличествоСлучайныхВариантов - 1);
#Иначе
		НомерКаталога = ТекущаяУниверсальнаяДатаВМиллисекундах() % КоличествоСлучайныхВариантов;
#КонецЕсли

		Если Счетчик > 1 И КоличествоСлучайныхВариантов < 26 * 26 * 26 * 26 * 26 Тогда
			КоличествоСлучайныхВариантов = КоличествоСлучайныхВариантов * 26;
		КонецЕсли;
		
		БуквыКаталога = "";
		КодПервойБуквы = КодСимвола("A", 1);
		
		Пока Истина Цикл
			НомерБуквы = НомерКаталога % 26;
			НомерКаталога = Цел(НомерКаталога / 26);
			
			КодКаталога = КодПервойБуквы + НомерБуквы;
			
			БуквыКаталога = БуквыКаталога + Символ(КодКаталога);
			Если НомерКаталога = 0 Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		ПодКаталог = ""; // Частичный путь.
		
		// По умолчанию вначале используется корень, если возможности нет,
		// то добавляется A, B, ... Z, .. ZZZZZ, .. AAAAA, .. AAAAAZ и т.д.
		Если  Счетчик = 0 Тогда
			ПодКаталог = "";
		Иначе
			ПодКаталог = БуквыКаталога;
			ЦиклНомер = Окр(Счетчик / 26);
			
			Если ЦиклНомер <> 0 Тогда
				ЦиклНомерСтрока = Строка(ЦиклНомер);
				ПодКаталог = ПодКаталог + ЦиклНомерСтрока;
			КонецЕсли;
			
			Если ЭтоЗарезервированноеИмяКаталога(ПодКаталог) Тогда
				Продолжить;
			КонецЕсли;
			
			ПодКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПодКаталог);
		КонецЕсли;
		
		ПолныйПодКаталог = ИмяКаталога + ПодКаталог;
		
		// Создание каталога для файлов.
		КаталогНаДиске = Новый Файл(ПолныйПодКаталог);
		Если НЕ КаталогНаДиске.Существует() Тогда
			Попытка
				СоздатьКаталог(ПолныйПодКаталог);
			Исключение
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось создать каталог ""%1"":
						|""%2"".'"),
					ПолныйПодКаталог,
					ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()) );
			КонецПопытки;
		КонецЕсли;
		
		ФайлПопытки = ПолныйПодКаталог + ИмяФайла;
		Счетчик = Счетчик + 1;
		
		// Проверка, есть ли файл с таким именем.
		ФайлНаДиске = Новый Файл(ФайлПопытки);
		Если НЕ ФайлНаДиске.Существует() Тогда  // Нет такого файла.
			ИтоговыйПуть = ПодКаталог + ИмяФайла;
			Успешно = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИтоговыйПуть;
	
КонецФункции

// Возвращает Истина, если файл с таким расширением находится в списке расширений.
Функция РасширениеФайлаВСписке(СписокРасширений, РасширениеФайла) Экспорт
	
	РасширениеФайлаБезТочки = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(РасширениеФайла);
	
	МассивРасширений = СтрРазделить(
		НРег(СписокРасширений), " ", Ложь);
	
	Если МассивРасширений.Найти(РасширениеФайлаБезТочки) <> Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Для пользовательского интерфейса.

// Возвращает Строку сообщения о недопустимости подписания занятого файла.
//
Функция СтрокаСообщенияОНедопустимостиПодписанияЗанятогоФайла(ФайлСсылка = Неопределено) Экспорт
	
	Если ФайлСсылка = Неопределено Тогда
		Возврат НСтр("ru = 'Нельзя подписать занятый файл.'");
	Иначе
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Нельзя подписать занятый файл: %1.'"),
			Строка(ФайлСсылка) );
	КонецЕсли;
	
КонецФункции

// Возвращает Строку сообщения о недопустимости подписания зашифрованного файла.
//
Функция СтрокаСообщенияОНедопустимостиПодписанияЗашифрованногоФайла(ФайлСсылка = Неопределено) Экспорт
	
	Если ФайлСсылка = Неопределено Тогда
		Возврат НСтр("ru = 'Нельзя подписать зашифрованный файл.'");
	Иначе
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Нельзя подписать зашифрованный файл: %1.'"),
						Строка(ФайлСсылка) );
	КонецЕсли;
	
КонецФункции

// Получить строку с представлением размера файла - например для отображения в Состояние при передаче файла.
Функция ПолучитьСтрокуСРазмеромФайла(Знач РазмерВМб) Экспорт
	
	Если РазмерВМб < 0.1 Тогда
		РазмерВМб = 0.1;
	КонецЕсли;	
	
	СтрокаРазмера = ?(РазмерВМб >= 1, Формат(РазмерВМб, "ЧДЦ=0"), Формат(РазмерВМб, "ЧДЦ=1; ЧН=0"));
	Возврат СтрокаРазмера;
	
КонецФункции	

// Получается индекс пиктограммы файла - индекс в картинке КоллекцияПиктограммФайлов.
Функция ПолучитьИндексПиктограммыФайла(Знач РасширениеФайла) Экспорт
	
	Если ТипЗнч(РасширениеФайла) <> Тип("Строка")
		ИЛИ ПустаяСтрока(РасширениеФайла) Тогда
		Возврат 0;
	КонецЕсли;
	
	РасширениеФайла = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(РасширениеФайла);
	
	Расширение = "." + НРег(РасширениеФайла) + ";";
	
	Если СтрНайти(".dt;.1cd;.cf;.cfu;", Расширение) <> 0 Тогда
		Возврат 6; // Файлы 1С.
		
	ИначеЕсли Расширение = ".mxl;" Тогда
		Возврат 8; // Табличный Файл.
		
	ИначеЕсли СтрНайти(".txt;.log;.ini;", Расширение) <> 0 Тогда
		Возврат 10; // Текстовый Файл.
		
	ИначеЕсли Расширение = ".epf;" Тогда
		Возврат 12; // Внешние обработки.
		
	ИначеЕсли СтрНайти(".ico;.wmf;.emf;",Расширение) <> 0 Тогда
		Возврат 14; // Картинки.
		
	ИначеЕсли СтрНайти(".htm;.html;.url;.mht;.mhtml;",Расширение) <> 0 Тогда
		Возврат 16; // HTML.
		
	ИначеЕсли СтрНайти(".doc;.dot;.rtf;",Расширение) <> 0 Тогда
		Возврат 18; // Файл Microsoft Word.
		
	ИначеЕсли СтрНайти(".xls;.xlw;",Расширение) <> 0 Тогда
		Возврат 20; // Файл Microsoft Excel.
		
	ИначеЕсли СтрНайти(".ppt;.pps;",Расширение) <> 0 Тогда
		Возврат 22; // Файл Microsoft PowerPoint.
		
	ИначеЕсли СтрНайти(".vsd;",Расширение) <> 0 Тогда
		Возврат 24; // Файл Microsoft Visio.
		
	ИначеЕсли СтрНайти(".mpp;",Расширение) <> 0 Тогда
		Возврат 26; // Файл Microsoft Visio.
		
	ИначеЕсли СтрНайти(".mdb;.adp;.mda;.mde;.ade;",Расширение) <> 0 Тогда
		Возврат 28; // База данных Microsoft Access.
		
	ИначеЕсли СтрНайти(".xml;",Расширение) <> 0 Тогда
		Возврат 30; // xml.
		
	ИначеЕсли СтрНайти(".msg;.eml;",Расширение) <> 0 Тогда
		Возврат 32; // Письмо электронной почты.
		
	ИначеЕсли СтрНайти(".zip;.rar;.arj;.cab;.lzh;.ace;",Расширение) <> 0 Тогда
		Возврат 34; // Архивы.
		
	ИначеЕсли СтрНайти(".exe;.com;.bat;.cmd;",Расширение) <> 0 Тогда
		Возврат 36; // Исполняемые файлы.
		
	ИначеЕсли СтрНайти(".grs;",Расширение) <> 0 Тогда
		Возврат 38; // Графическая схема.
		
	ИначеЕсли СтрНайти(".geo;",Расширение) <> 0 Тогда
		Возврат 40; // Географическая схема.
		
	ИначеЕсли СтрНайти(".jpg;.jpeg;.jp2;.jpe;",Расширение) <> 0 Тогда
		Возврат 42; // jpg.
		
	ИначеЕсли СтрНайти(".bmp;.dib;",Расширение) <> 0 Тогда
		Возврат 44; // bmp.
		
	ИначеЕсли СтрНайти(".tif;.tiff;",Расширение) <> 0 Тогда
		Возврат 46; // tif.
		
	ИначеЕсли СтрНайти(".gif;",Расширение) <> 0 Тогда
		Возврат 48; // gif.
		
	ИначеЕсли СтрНайти(".png;",Расширение) <> 0 Тогда
		Возврат 50; // png.
		
	ИначеЕсли СтрНайти(".pdf;",Расширение) <> 0 Тогда
		Возврат 52; // pdf.
		
	ИначеЕсли СтрНайти(".odt;",Расширение) <> 0 Тогда
		Возврат 54; // Open Office writer.
		
	ИначеЕсли СтрНайти(".odf;",Расширение) <> 0 Тогда
		Возврат 56; // Open Office math.
		
	ИначеЕсли СтрНайти(".odp;",Расширение) <> 0 Тогда
		Возврат 58; // Open Office Impress.
		
	ИначеЕсли СтрНайти(".odg;",Расширение) <> 0 Тогда
		Возврат 60; // Open Office draw.
		
	ИначеЕсли СтрНайти(".ods;",Расширение) <> 0 Тогда
		Возврат 62; // Open Office calc.
		
	ИначеЕсли СтрНайти(".mp3;",Расширение) <> 0 Тогда
		Возврат 64;
		
	ИначеЕсли СтрНайти(".erf;",Расширение) <> 0 Тогда
		Возврат 66; // Внешние отчеты.
		
	ИначеЕсли СтрНайти(".docx;",Расширение) <> 0 Тогда
		Возврат 68; // Файл Microsoft Word docx.
		
	ИначеЕсли СтрНайти(".xlsx;",Расширение) <> 0 Тогда
		Возврат 70; // Файл Microsoft Excel xlsx.
		
	ИначеЕсли СтрНайти(".pptx;",Расширение) <> 0 Тогда
		Возврат 72; // Файл Microsoft PowerPoint pptx.
		
	ИначеЕсли СтрНайти(".p7s;",Расширение) <> 0 Тогда
		Возврат 74; // Файл подписи.
		
	ИначеЕсли СтрНайти(".p7m;",Расширение) <> 0 Тогда
		Возврат 76; // зашифрованное сообщение.
	Иначе
		Возврат 4;
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Прочие

// Только для внутреннего использования.
Процедура ЗаполнитьСтатусПодписи(СтрокаПодписи, ТекущаяДата) Экспорт
	
	Если Не ЗначениеЗаполнено(СтрокаПодписи.ДатаПроверкиПодписи) Тогда
		СтрокаПодписи.Статус = "";
		Возврат;
	КонецЕсли;
	
	Если СтрокаПодписи.ПодписьВерна
		И ЗначениеЗаполнено(СтрокаПодписи.СрокДействияПоследнейМеткиВремени)
		И СтрокаПодписи.СрокДействияПоследнейМеткиВремени < ТекущаяДата Тогда
		СтрокаПодписи.Статус = НСтр("ru = 'Была верна на дату подписи'");
	ИначеЕсли СтрокаПодписи.ПодписьВерна Тогда
		СтрокаПодписи.Статус = НСтр("ru = 'Верна'");
	ИначеЕсли СтрокаПодписи.ТребуетсяПроверка Тогда
		СтрокаПодписи.Статус = НСтр("ru = 'Требуется проверка'");
	Иначе
		СтрокаПодписи.Статус = НСтр("ru = 'Неверна'");
	КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Синхронизация файлов

Функция АдресВОблачномСервисе(Сервис, Href) Экспорт
	
	АдресОбъекта = Href;
	
	Если Не ПустаяСтрока(Сервис) Тогда
		Если Сервис = "https://webdav.yandex.com" Тогда
			АдресОбъекта = СтрЗаменить(Href, "https://webdav.yandex.com", "https://disk.yandex.com/client/disk");
		// Локализация
		ИначеЕсли Сервис = "https://webdav.yandex.ru" Тогда
			АдресОбъекта = СтрЗаменить(Href, "https://webdav.yandex.ru", "https://disk.yandex.ru/client/disk");
		// Конец Локализация
		ИначеЕсли Сервис = "https://dav.box.com/dav" Тогда
			АдресОбъекта = "https://app.box.com/files/0/";
		ИначеЕсли Сервис = "https://dav.dropdav.com" Тогда
			АдресОбъекта = "https://www.dropbox.com/home/";
		КонецЕсли;
	КонецЕсли;
	
	Возврат АдресОбъекта;
	
КонецФункции

// Параметры занятия файла на редактирование.
//
// Возвращаемое значение:
//   Структура:
//     * УникальныйИдентификатор - уникальный идентификатор формы.
//     * Пользователь - СправочникСсылка.Пользователи
//     * ДополнительныеСвойства - Структура - дополнительные свойства для записи файла.
//
Функция ПараметрыЗанятияФайла() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("УникальныйИдентификатор");
	Параметры.Вставить("Пользователь");
	Параметры.Вставить("ДополнительныеСвойства");
	Параметры.Вставить("ВызыватьИсключение", Истина);
	
	Возврат Параметры;
	
КонецФункции

// Описание подключения внешней компоненты сканирования.
//
// Возвращаемое значение:
//  Структура:
//   * ПолноеИмяМакета - Строка
//   * ИмяОбъекта      - Строка
//
Функция ОписаниеКомпоненты() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ИмяОбъекта", "ImageScan");
	Параметры.Вставить("ПолноеИмяМакета", "ОбщийМакет.КомпонентаСканированияДокументов");
	Возврат Параметры;
	
КонецФункции

#Область ИзвлечениеТекста

// Извлекает текст в соответствии с кодировкой.
// Если кодировка не задана - сама вычисляет кодировку.
//
Функция ИзвлечьТекстИзТекстовогоФайла(ПолноеИмяФайла, Кодировка, Отказ) Экспорт
	
	ИзвлеченныйТекст = "";
	
#Если Не ВебКлиент Тогда
	
	// Определение кодировки.
	Если Не ЗначениеЗаполнено(Кодировка) Тогда
		Кодировка = Неопределено;
	КонецЕсли;
	
	Попытка
		КодировкаДляЧтения = ?(Кодировка = "utf-8_WithoutBOM", "utf-8", Кодировка);
		ЧтениеТекста = Новый ЧтениеТекста(ПолноеИмяФайла, КодировкаДляЧтения);
		ИзвлеченныйТекст = ЧтениеТекста.Прочитать();
	Исключение
		Отказ = Истина;
		ИзвлеченныйТекст = "";
	КонецПопытки;
	
#КонецЕсли
	
	Возврат ИзвлеченныйТекст;
	
КонецФункции

// Извлечь текст из файла OpenDocument и возвратить его в виде строки.
//
Функция ИзвлечьТекстOpenDocument(ПутьКФайлу, Отказ) Экспорт
	
	ИзвлеченныйТекст = "";
	
#Если Не ВебКлиент И НЕ МобильныйКлиент Тогда
	
	ВременнаяПапкаДляРазархивирования = ПолучитьИмяВременногоФайла("");
	ВременныйZIPФайл = ПолучитьИмяВременногоФайла("zip"); 
	
	КопироватьФайл(ПутьКФайлу, ВременныйZIPФайл);
	Файл = Новый Файл(ВременныйZIPФайл);
	Файл.УстановитьТолькоЧтение(Ложь);

	Попытка
		Архив = Новый ЧтениеZipФайла();
		Архив.Открыть(ВременныйZIPФайл);
		Архив.ИзвлечьВсе(ВременнаяПапкаДляРазархивирования, РежимВосстановленияПутейФайловZIP.Восстанавливать);
		Архив.Закрыть();
		ЧтениеXML = Новый ЧтениеXML();
		
		ЧтениеXML.ОткрытьФайл(ВременнаяПапкаДляРазархивирования + "/content.xml");
		ИзвлеченныйТекст = ИзвлечьТекстИзContentXML(ЧтениеXML);
		ЧтениеXML.Закрыть();
	Исключение
		// Не считаем ошибкой, т.к. например расширение OTF может быть как OpenDocument, так и шрифт OpenType.
		Архив     = Неопределено;
		ЧтениеXML = Неопределено;
		Отказ = Истина;
		ИзвлеченныйТекст = "";
	КонецПопытки;
	
	УдалитьФайлы(ВременнаяПапкаДляРазархивирования);
	УдалитьФайлы(ВременныйZIPФайл);
	
#КонецЕсли
	
	Возврат ИзвлеченныйТекст;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Извлечь текст из объекта ЧтениеXML (прочитанного из файла OpenDocument).
Функция ИзвлечьТекстИзContentXML(ЧтениеXML)
	
	ИзвлеченныйТекст = "";
	ПоследнееИмяТега = "";
	
#Если Не ВебКлиент Тогда
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			ПоследнееИмяТега = ЧтениеXML.Имя;
			
			Если ЧтениеXML.Имя = "text:p" Тогда
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + Символы.ПС;
				КонецЕсли;
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "text:line-break" Тогда
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + Символы.ПС;
				КонецЕсли;
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "text:tab" Тогда
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + Символы.Таб;
				КонецЕсли;
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "text:s" Тогда
				
				СтрокаДобавки = " "; // пробел
				
				Если ЧтениеXML.КоличествоАтрибутов() > 0 Тогда
					Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
						Если ЧтениеXML.Имя = "text:c"  Тогда
							ЧислоПробелов = Число(ЧтениеXML.Значение);
							СтрокаДобавки = "";
							Для Индекс = 0 По ЧислоПробелов - 1 Цикл
								СтрокаДобавки = СтрокаДобавки + " "; // пробел
							КонецЦикла;
						КонецЕсли;
					КонецЦикла
				КонецЕсли;
				
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + СтрокаДобавки;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
			
			Если СтрНайти(ПоследнееИмяТега, "text:") <> 0 Тогда
				ИзвлеченныйТекст = ИзвлеченныйТекст + ЧтениеXML.Значение;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
#КонецЕсли

	Возврат ИзвлеченныйТекст;
	
КонецФункции

// Получить имя сканированного файла, вида ДМ-00000012, где ДМ - префикс базы.
//
// Параметры:
//  НомерФайла  - Число - целое число, например, 12.
//  ПрефиксБазы - Строка - префикс базы, например, "ДМ".
//
// Возвращаемое значение:
//  Строка - имя сканированного файла, например, "ДМ-00000012".
//
Функция ИмяСканированногоФайла(НомерФайла, ПрефиксБазы) Экспорт
	
	ИмяФайла = "";
	Если НЕ ПустаяСтрока(ПрефиксБазы) Тогда
		ИмяФайла = ПрефиксБазы + "-";
	КонецЕсли;
	
	ИмяФайла = ИмяФайла + Формат(НомерФайла, "ЧЦ=9; ЧВН=; ЧГ=0");
	Возврат ИмяФайла;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

Функция ЭтоЗарезервированноеИмяКаталога(ИмяПодКаталога)
	
	СписокИмен = Новый Соответствие();
	СписокИмен.Вставить("CON", Истина);
	СписокИмен.Вставить("PRN", Истина);
	СписокИмен.Вставить("AUX", Истина);
	СписокИмен.Вставить("NUL", Истина);
	
	Возврат СписокИмен[ИмяПодКаталога] <> Неопределено;
	
КонецФункции

// Инициализирует структуру параметров для добавления файла.
// Для использования в РаботаСФайлами.ДобавитьФайл и РаботаСФайламиСлужебныйВызовСервера.ДобавитьФайл.
//
Функция ПараметрыДобавленияФайла(ДополнительныеРеквизиты = Неопределено) Экспорт
	
	Если ТипЗнч(ДополнительныеРеквизиты) = Тип("Структура") Тогда
		РеквизитыФайла = Неопределено;
		ПараметрыДобавления = ДополнительныеРеквизиты;
	Иначе
		
		ПараметрыДобавления = Новый Структура;
		РеквизитыФайла = ?(ТипЗнч(ДополнительныеРеквизиты) = Тип("Массив"),
			ДополнительныеРеквизиты,
			СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ДополнительныеРеквизиты, ",", Истина, Истина));
		
	КонецЕсли;
	
	ДобавитьСвойство(ПараметрыДобавления, "Автор");
	ДобавитьСвойство(ПараметрыДобавления, "ВладелецФайлов");
	ДобавитьСвойство(ПараметрыДобавления, "ИмяБезРасширения", "");
	ДобавитьСвойство(ПараметрыДобавления, "РасширениеБезТочки", "");
	ДобавитьСвойство(ПараметрыДобавления, "ВремяИзмененияУниверсальное");
	ДобавитьСвойство(ПараметрыДобавления, "ГруппаФайлов");
	ДобавитьСвойство(ПараметрыДобавления, "Служебный", Ложь);
	
	Если РеквизитыФайла = Неопределено Тогда
		Возврат ПараметрыДобавления;
	КонецЕсли;
	
	Для Каждого ДополнительныйРеквизит Из РеквизитыФайла Цикл
		ДобавитьСвойство(ПараметрыДобавления, ДополнительныйРеквизит);
	КонецЦикла;
	
	Возврат ПараметрыДобавления;
	
КонецФункции

Процедура ДобавитьСвойство(Коллекция, Ключ, Значение = Неопределено)
	
	Если Не Коллекция.Свойство(Ключ) Тогда
		Коллекция.Вставить(Ключ, Значение);
	КонецЕсли;
	
КонецПроцедуры

// Автоматически определяет и возвращает кодировку текстового файла.
//
// Параметры:
//  ДанныеДляАнализа - ДвоичныеДанные, Строка - данные для определения кодировки или адрес данных.
//  Расширение         - Строка - расширение файла.
//
// Возвращаемое значение:
//  Строка
//
Функция ОпределитьКодировкуДвоичныхДанных(ДанныеДляАнализа, Расширение) Экспорт
	
	Если ТипЗнч(ДанныеДляАнализа) = Тип("ДвоичныеДанные") Тогда
		ДвоичныеДанные = ДанныеДляАнализа;
	ИначеЕсли ЭтоАдресВременногоХранилища(ДанныеДляАнализа) Тогда
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДанныеДляАнализа);
	Иначе
		ДвоичныеДанные = Неопределено;
	КонецЕсли;

	Кодировка = Неопределено;
	
	Если ДвоичныеДанные <> Неопределено Тогда
		Кодировка = КодировкаИзДвоичныхДанных(ДвоичныеДанные);
		Если Не ЗначениеЗаполнено(Кодировка) Тогда
			Если СтрЗаканчиваетсяНа(НРег(Расширение), "xml") Тогда
				Кодировка = КодировкаИзОбъявленияXML(ДвоичныеДанные);
			Иначе
				Кодировка = КодировкаИзСоответствияАлфавиту(ДвоичныеДанные);
			КонецЕсли;
			
			Если НРег(Кодировка) = "utf-8" Тогда
				Кодировка = НРег(Кодировка) + "_WithoutBOM";
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	Возврат Кодировка;
	
КонецФункции

// Возвращает кодировку, полученную из двоичных данных файла, если
// файл содержит сигнатуру BOM в начале.
//
// Параметры:
//  ДвоичныеДанные - ДвоичныеДанные - двоичные данные файла.
//
// Возвращаемое значение:
//  Строка - кодировка файла. Если файл не содержит сигнатуру BOM, 
//           возвращает пустую строку.
//
Функция КодировкаИзДвоичныхДанных(ДвоичныеДанные)

	ЧтениеДанных        = Новый ЧтениеДанных(ДвоичныеДанные);
	БуферДвоичныхДанных = ЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(5);
	
	Возврат КодировкаBOM(БуферДвоичныхДанных);

КонецФункции

// Возвращает кодировку, полученную из двоичных данных файла, если
// файл содержит объявление XML.
//
// Параметры:
//  ДвоичныеДанные - ДвоичныеДанные- двоичные данные файла.
//
// Возвращаемое значение:
//  Строка - кодировка файла. Если невозможно прочитать 
//                          объявление XML, возвращает пустую строку.
//
Функция КодировкаИзОбъявленияXML(ДвоичныеДанные)
	
#Если ВебКлиент Тогда
	Строка = ПолучитьСтрокуИзДвоичныхДанных(ДвоичныеДанные);
	ПервыйТег = СтрРазделить(Строка, ">", Ложь)[0];
	Кодировка = Сред(ПервыйТег, СтрНайти(ПервыйТег, "encoding") + 10);
	КодировкаXML = СтрРазделить(Кодировка, """")[0];
#Иначе
	БуферДвоичныхДанных = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(ДвоичныеДанные);
	ПотокВПамяти = Новый ПотокВПамяти(БуферДвоичныхДанных);
	КодировкаXML = "";
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьПоток(ПотокВПамяти);
	Попытка
		ЧтениеXML.ПерейтиКСодержимому();
		КодировкаXML = ЧтениеXML.КодировкаXML;
	Исключение
		КодировкаXML = "";
	КонецПопытки;
	ЧтениеXML.Закрыть();
	ПотокВПамяти.Закрыть();
#КонецЕсли
	Возврат КодировкаXML;
	
КонецФункции

// Возвращает кодировку текста, полученную из сигнатуры BOM в начале.
//
// Параметры:
//  БуферДвоичныхДанных - Число - коллекция байтов для определения кодировки.
//
// Возвращаемое значение:
//  Строка - кодировка файла. Если файл не содержит сигнатуру BOM, 
//                       возвращает пустую строку.
//
Функция КодировкаBOM(БуферДвоичныхДанных)
	
	ПрочитанныеБайты = Новый Массив(5);
	Для Индекс = 0 По 4 Цикл
		Если Индекс < БуферДвоичныхДанных.Размер Тогда
			ПрочитанныеБайты[Индекс] = БуферДвоичныхДанных[Индекс];
		Иначе
			ПрочитанныеБайты[Индекс] = ЧислоИзШестнадцатеричнойСтроки("0xA5");
		КонецЕсли;
	КонецЦикла;
	
	Если ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0xFE")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0xFF") Тогда
		Кодировка = "UTF-16BE";
	ИначеЕсли ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0xFF")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0xFE") Тогда
		Если ПрочитанныеБайты[2] = ЧислоИзШестнадцатеричнойСтроки("0x00")
			И ПрочитанныеБайты[3] = ЧислоИзШестнадцатеричнойСтроки("0x00") Тогда
			Кодировка = "UTF-32LE";
		Иначе
			Кодировка = "UTF-16LE";
		КонецЕсли;
	ИначеЕсли ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0xEF")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0xBB")
		И ПрочитанныеБайты[2] = ЧислоИзШестнадцатеричнойСтроки("0xBF") Тогда
		Кодировка = "UTF-8";
	ИначеЕсли ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0x00")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0x00")
		И ПрочитанныеБайты[2] = ЧислоИзШестнадцатеричнойСтроки("0xFE")
		И ПрочитанныеБайты[3] = ЧислоИзШестнадцатеричнойСтроки("0xFF") Тогда
		Кодировка = "UTF-32BE";
	ИначеЕсли ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0x0E")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0xFE")
		И ПрочитанныеБайты[2] = ЧислоИзШестнадцатеричнойСтроки("0xFF") Тогда
		Кодировка = "SCSU";
	ИначеЕсли ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0xFB")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0xEE")
		И ПрочитанныеБайты[2] = ЧислоИзШестнадцатеричнойСтроки("0x28") Тогда
		Кодировка = "BOCU-1";
	ИначеЕсли ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0x2B")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0x2F")
		И ПрочитанныеБайты[2] = ЧислоИзШестнадцатеричнойСтроки("0x76")
		И (ПрочитанныеБайты[3] = ЧислоИзШестнадцатеричнойСтроки("0x38")
			Или ПрочитанныеБайты[3] = ЧислоИзШестнадцатеричнойСтроки("0x39")
			Или ПрочитанныеБайты[3] = ЧислоИзШестнадцатеричнойСтроки("0x2B")
			Или ПрочитанныеБайты[3] = ЧислоИзШестнадцатеричнойСтроки("0x2F")) Тогда
		Кодировка = "UTF-7";
	ИначеЕсли ПрочитанныеБайты[0] = ЧислоИзШестнадцатеричнойСтроки("0xDD")
		И ПрочитанныеБайты[1] = ЧислоИзШестнадцатеричнойСтроки("0x73")
		И ПрочитанныеБайты[2] = ЧислоИзШестнадцатеричнойСтроки("0x66")
		И ПрочитанныеБайты[3] = ЧислоИзШестнадцатеричнойСтроки("0x73") Тогда
		Кодировка = "UTF-EBCDIC";
	Иначе
		Кодировка = "";
	КонецЕсли;
	
	Возврат Кодировка;
	
КонецФункции

// Возвращает наиболее подходящую кодировку текста, полученную путем сравнения с алфавитом.
//
// Параметры:
//  ДанныеТекста - ДвоичныеДанные - двоичные данные файла.
//
// Возвращаемое значение:
//  Строка - кодировка файла.
//
Функция КодировкаИзСоответствияАлфавиту(ДанныеТекста)
	
	Кодировки = Кодировки();
	Кодировки.Удалить(Кодировки.НайтиПоЗначению("utf-8_WithoutBOM"));
	
	КодировкаKOI8R = Кодировки.НайтиПоЗначению("koi8-r");
	Кодировки.Сдвинуть(КодировкаKOI8R, -Кодировки.Индекс(КодировкаKOI8R));
	
	КодировкаWin1251 = Кодировки.НайтиПоЗначению("windows-1251");
	Кодировки.Сдвинуть(КодировкаWin1251, -Кодировки.Индекс(КодировкаWin1251));
	
	КодировкаUTF8 = Кодировки.НайтиПоЗначению("utf-8");
	Кодировки.Сдвинуть(КодировкаUTF8, -Кодировки.Индекс(КодировкаUTF8));
	
	СоответствующаяКодировка = "";
	МаксимальноеСоответствиеКодировки = 0;
	Для Каждого Кодировка Из Кодировки Цикл
		
		СоответствиеКодировки = ПроцентСоответствияАлфавиту(ДанныеТекста, Кодировка.Значение);
		Если СоответствиеКодировки > 0.95 Тогда
			Возврат Кодировка.Значение;
		КонецЕсли;
		
		Если СоответствиеКодировки > МаксимальноеСоответствиеКодировки Тогда
			СоответствующаяКодировка = Кодировка.Значение;
			МаксимальноеСоответствиеКодировки = СоответствиеКодировки;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СоответствующаяКодировка;
	
КонецФункции

Функция ПроцентСоответствияАлфавиту(ДвоичныеДанные, ПроверяемаяКодировка)
	
	// АПК:1036-выкл, АПК:163-выкл - алфавит не требует проверки орфографии.
	Алфавит = "АаБбВвГгДдЕеЁёЖжЗзИиЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЪъЫыЬьЭэЮюЯя"
		+ "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz"
		+ "1234567890 ";
	// АПК:1036-вкл, АПК:163-вкл
	
	ПотокАлфавита = Новый ПотокВПамяти();
	ЗаписьАлфавита = Новый ЗаписьДанных(ПотокАлфавита);
	ЗаписьАлфавита.ЗаписатьСтроку(Алфавит, ПроверяемаяКодировка);
	ЗаписьАлфавита.Закрыть();
	
	ДанныеАлфавита = ПотокАлфавита.ЗакрытьИПолучитьДвоичныеДанные();
	ЧтениеДанныхАлфавита = Новый ЧтениеДанных(ДанныеАлфавита);
	БуферАлфавитаВКодировке = ЧтениеДанныхАлфавита.ПрочитатьВБуферДвоичныхДанных();
	
	Индекс = 0;
	СимволыАлфавита = Новый Массив;
	Пока Индекс <= БуферАлфавитаВКодировке.Размер - 1 Цикл
		
		ТекущийСимвол = БуферАлфавитаВКодировке[Индекс];
		
		// Символы кириллицы в кодировке UTF-8 - двухбайтовые.
		Если ПроверяемаяКодировка = "utf-8"
			И (ТекущийСимвол = 208
			Или ТекущийСимвол = 209) Тогда
			
			Индекс = Индекс + 1;
			ТекущийСимвол = Формат(ТекущийСимвол, "ЧН=0; ЧГ=") + Формат(БуферАлфавитаВКодировке[Индекс], "ЧН=0; ЧГ=");
		КонецЕсли;
		
		Индекс = Индекс + 1;
		СимволыАлфавита.Добавить(ТекущийСимвол);
		
	КонецЦикла;
	
	ЧтениеДанныхТекста = Новый ЧтениеДанных(ДвоичныеДанные);
	БуферДанныхТекста = ЧтениеДанныхТекста.ПрочитатьВБуферДвоичныхДанных(?(ПроверяемаяКодировка = "utf-8", 200, 100));
	РазмерБуфераТекста = БуферДанныхТекста.Размер;
	КоличествоСимволов = РазмерБуфераТекста;
	
	Индекс = 0;
	КоличествоВхождений = 0;
	Пока Индекс <= РазмерБуфераТекста - 1 Цикл
		
		ТекущийСимвол = БуферДанныхТекста[Индекс];
		Если ПроверяемаяКодировка = "utf-8"
			И (ТекущийСимвол = 208
			Или ТекущийСимвол = 209) Тогда
			
			// Если последний байт в буфере является первым байтом двухбайтового символа, игнорируем его.
			Если Индекс = РазмерБуфераТекста - 1 Тогда
				Прервать;
			КонецЕсли;
			
			Индекс = Индекс + 1;
			КоличествоСимволов = КоличествоСимволов - 1;
			ТекущийСимвол = Формат(ТекущийСимвол, "ЧН=0; ЧГ=") + Формат(БуферДанныхТекста[Индекс], "ЧН=0; ЧГ=");
			
		КонецЕсли;
		
		Индекс = Индекс + 1;
		Если СимволыАлфавита.Найти(ТекущийСимвол) <> Неопределено Тогда
			КоличествоВхождений = КоличествоВхождений + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ?(КоличествоСимволов = 0, 100, КоличествоВхождений/КоличествоСимволов);
	
КонецФункции

// Возвращает таблицу имен кодировок.
//
// Возвращаемое значение:
//   СписокЗначений:
//     * Значение - Строка - например "ibm852".
//     * Представление - Строка - например "ibm852 (Центральноевропейская DOS)".
//
Функция Кодировки() Экспорт

	СписокКодировок = Новый СписокЗначений;
	
	СписокКодировок.Добавить("ibm852",       НСтр("ru = 'IBM852 (Центральноевропейская DOS)'"));
	СписокКодировок.Добавить("ibm866",       НСтр("ru = 'IBM866 (Кириллица DOS)'"));
	СписокКодировок.Добавить("iso-8859-1",   НСтр("ru = 'ISO-8859-1 (Западноевропейская ISO)'"));
	СписокКодировок.Добавить("iso-8859-2",   НСтр("ru = 'ISO-8859-2 (Центральноевропейская ISO)'"));
	СписокКодировок.Добавить("iso-8859-3",   НСтр("ru = 'ISO-8859-3 (Латиница 3 ISO)'"));
	СписокКодировок.Добавить("iso-8859-4",   НСтр("ru = 'ISO-8859-4 (Балтийская ISO)'"));
	СписокКодировок.Добавить("iso-8859-5",   НСтр("ru = 'ISO-8859-5 (Кириллица ISO)'"));
	СписокКодировок.Добавить("iso-8859-7",   НСтр("ru = 'ISO-8859-7 (Греческая ISO)'"));
	СписокКодировок.Добавить("iso-8859-9",   НСтр("ru = 'ISO-8859-9 (Турецкая ISO)'"));
	СписокКодировок.Добавить("iso-8859-15",  НСтр("ru = 'ISO-8859-15 (Латиница 9 ISO)'"));
	СписокКодировок.Добавить("koi8-r",       НСтр("ru = 'KOI8-R (Кириллица KOI8-R)'"));
	СписокКодировок.Добавить("koi8-u",       НСтр("ru = 'KOI8-U (Кириллица KOI8-U)'"));
	СписокКодировок.Добавить("us-ascii",     НСтр("ru = 'US-ASCII (США)'"));
	СписокКодировок.Добавить("utf-8",        НСтр("ru = 'UTF-8 (Юникод UTF-8)'"));
	СписокКодировок.Добавить("utf-8_WithoutBOM", НСтр("ru = 'UTF-8 (Юникод UTF-8 без BOM)'"));
	СписокКодировок.Добавить("windows-1250", НСтр("ru = 'Windows-1250 (Центральноевропейская Windows)'"));
	СписокКодировок.Добавить("windows-1251", НСтр("ru = 'windows-1251 (Кириллица Windows)'"));
	СписокКодировок.Добавить("windows-1252", НСтр("ru = 'Windows-1252 (Западноевропейская Windows)'"));
	СписокКодировок.Добавить("windows-1253", НСтр("ru = 'Windows-1253 (Греческая Windows)'"));
	СписокКодировок.Добавить("windows-1254", НСтр("ru = 'Windows-1254 (Турецкая Windows)'"));
	СписокКодировок.Добавить("windows-1257", НСтр("ru = 'Windows-1257 (Балтийская Windows)'"));
	
	Возврат СписокКодировок;

КонецФункции

Функция ПараметрыСканирования() Экспорт
	
	ПараметрыСканирования = Новый Структура; 
	ПараметрыСканирования.Вставить("ПоказыватьДиалог", Истина);
	ПараметрыСканирования.Вставить("ВыбранноеУстройство", "");
	ПараметрыСканирования.Вставить("ФорматКартинки", "png");
	ПараметрыСканирования.Вставить("Разрешение", 200);
	ПараметрыСканирования.Вставить("Цветность", 1);
	ПараметрыСканирования.Вставить("Поворот", 0);
	ПараметрыСканирования.Вставить("РазмерБумаги", 1);
	ПараметрыСканирования.Вставить("КачествоJPG", 100);
	ПараметрыСканирования.Вставить("СжатиеTIFF", 6);
	ПараметрыСканирования.Вставить("ДвустороннееСканирование", Ложь);
	ПараметрыСканирования.Вставить("СохранятьВPDF", Ложь);
	ПараметрыСканирования.Вставить("ИспользоватьImageMagickДляПреобразованияВPDF", Ложь);
	Возврат ПараметрыСканирования;
	
КонецФункции

#КонецОбласти