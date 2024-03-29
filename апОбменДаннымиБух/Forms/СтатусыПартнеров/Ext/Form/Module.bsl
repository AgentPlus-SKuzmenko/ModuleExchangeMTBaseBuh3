﻿
#Область СовместимостьСПлатформой_8_3_5

// Подставляет параметры в строку. Максимально возможное число параметров - 5.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров начинается с единицы.
//
// Параметры:
//  СтрокаПодстановки  - Строка - шаблон строки с параметрами (вхождениями вида "%ИмяПараметра");
//  Параметр<n>        - Строка - подставляемый параметр.
//
// Возвращаемое значение:
//  Строка   - текстовая строка с подставленными параметрами.
//
&НаКлиентеНаСервереБезКонтекста
Функция СтрШаблон_(СтрокаПодстановки,
	Параметр1, Параметр2 = Неопределено, Параметр3 = Неопределено, Параметр4 = Неопределено, Параметр5 = Неопределено)
	
	Результат = СтрЗаменить(СтрокаПодстановки, "%1", Параметр1);
	Результат = СтрЗаменить(Результат, "%2", Параметр2);
	Результат = СтрЗаменить(Результат, "%3", Параметр3);
	Результат = СтрЗаменить(Результат, "%4", Параметр4);
	Результат = СтрЗаменить(Результат, "%5", Параметр5);
	
	Возврат Результат;
	
КонецФункции
	
// Разбивает строку на несколько строк по разделителю. Разделитель может иметь любую длину.
//
// Параметры:
//  Строка                 - Строка - текст с разделителями;
//  Разделитель            - Строка - разделитель строк текста, минимум 1 символ;
//  ПропускатьПустыеСтроки - Булево - признак необходимости включения в результат пустых строк.
//    Если параметр не задан, то функция работает в режиме совместимости со своей предыдущей версией:
//     - для разделителя-пробела пустые строки не включаются в результат, для остальных разделителей пустые строки
//       включаются в результат.
//     Е если параметр Строка не содержит значащих символов или не содержит ни одного символа (пустая строка), то в
//       случае разделителя-пробела результатом функции будет массив, содержащий одно значение "" (пустая строка), а
//       при других разделителях результатом функции будет пустой массив.
//  СокращатьНепечатаемыеСимволы - Булево - сокращать непечатаемые символы по краям каждой из найденных подстрок.
//
// Возвращаемое значение:
//  Массив - массив строк.
&НаКлиентеНаСервереБезКонтекста 
Функция СтрРазделить_(Знач Строка, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено, СокращатьНепечатаемыеСимволы = Ложь)
	
	Результат = Новый Массив;
	
	// Для обеспечения обратной совместимости.
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//
	
	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Если СокращатьНепечатаемыеСимволы Тогда
				Результат.Добавить(СокрЛП(Подстрока));
			Иначе
				Результат.Добавить(Подстрока);
			КонецЕсли;
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Если СокращатьНепечатаемыеСимволы Тогда
			Результат.Добавить(СокрЛП(Строка));
		Иначе
			Результат.Добавить(Строка);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

///  Объединяет строки из массива в строку с разделителями.
//
// Параметры:
//  Массив      - Массив - массив строк которые необходимо объединить в одну строку;
//  Разделитель - Строка - любой набор символов, который будет использован в качестве разделителя.
//
// Возвращаемое значение:
//  Строка - строка с разделителями.
// 
&НаКлиентеНаСервереБезКонтекста 
Функция СтрСоединить_(Массив, Разделитель = ",", СокращатьНепечатаемыеСимволы = Ложь)

	Результат = "";
	ТекРазделитель = "";
	
	Для Индекс = 0 По Массив.ВГраница() Цикл
		
		Подстрока = Массив[Индекс];
		
		Если СокращатьНепечатаемыеСимволы Тогда
			Подстрока = СокрЛП(Подстрока);
		КонецЕсли;
		
		Если ТипЗнч(Подстрока) <> Тип("Строка") Тогда
			Подстрока = Строка(Подстрока);
		КонецЕсли;
		
		Результат = Результат + ТекРазделитель + Подстрока;
		
		Если Индекс = 0 Тогда
			ТекРазделитель = Разделитель;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

// СовместимостьСПлатформой_8_3_5
#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекОбъект.ИнициализироватьКонтекстФормы(СтррКонтекст, Параметры);
	ВосстановитьНастройкиСервер();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ГруппаКоманднаяПанель.ЦветФона = СтррКонтекст.Цвета.ФонРаздела;	
	УстановитьМодифицированостьФормы(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "АПНастройкиСброшены" Тогда
		
		ЭтаФорма.Модифицированность = Ложь;
		Закрыть();
		
	ИначеЕсли ИмяСобытия = "АППроверкаУникальностиЗапускаОбработкиОбмена" Тогда
		
		Если Параметр <> СтррКонтекст.ВХОбщиеПараметры Тогда // второй экземпляр обработки справшивает - уже открыта обработка или нет
			Оповестить("АПЗакрытьОбработкуОбменДанными", Параметр); // шлем событие закрытия обработки с конкретным ключем сеанса
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Если ЭтаФорма.Модифицированность Тогда
		Отказ = Истина;
		Оповещение = Новый ОписаниеОповещения("СохранитьВсеПродолжить", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

//Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСтатусыПартнеров

&НаКлиенте
Процедура СтатусыПартнеровПриИзменении(Элемент)
	
	УстановитьМодифицированостьФормы(Истина);

КонецПроцедуры

&НаКлиенте
Процедура СтатусыПартнеровЦветНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;	
	
	СтрокаТ = Элементы.СтатусыПартнеров.ТекущиеДанные;
	
	Если СтрокаТ <> Неопределено Тогда
		
		Цвет = ?(Не ПустаяСтрока(СтрокаТ.Цвет), СтрокаТ.Цвет, "0,0,0");
		стррПараметры = Новый Структура("ПараметрыВыбора", Новый Структура("Цвет", Цвет));
		Оповещение = Новый ОписаниеОповещения("СтатусыПартнеровЦветВыборЗавершение", ЭтотОбъект);
		ОткрытьФормуОбработки("ВыборЦвета", стррПараметры, ЭтаФорма.КлючУникальности, Оповещение);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СтатусыПартнеровЦветВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		СтрокаТ = Элементы.СтатусыПартнеров.ТекущиеДанные;
		Если СтрокаТ <> Неопределено Тогда
			СтрокаТ.Цвет = Результат.Цвет;
		КонецЕсли;
		УстановитьМодифицированостьФормы(Истина);
		
	КонецЕсли;
	
КонецПроцедуры


//dm_17.10.17:Внесены изменения
&НаКлиенте
Процедура СтатусыПартнеровПартнерыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
    //dm_17.10.17:Замена
	//Элементы.СтатусыПартнеров.ТекущиеДанные.Партнеры.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Партнеры");
	Элементы.СтатусыПартнеров.ТекущиеДанные.Партнеры.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусыПартнеровПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)

	ВыбранныйСтатус = Элементы.СтатусыПартнеров.ТекущиеДанные;
	Если ВыбранныйСтатус <> Неопределено Тогда
		Если ПустаяСтрока(ВыбранныйСтатус.Идентификатор) Тогда
			ВыбранныйСтатус.Идентификатор = Строка(Новый УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СтатусыПартнеровПередУдалением(Элемент, Отказ)

	Отказ = Истина;	
	
	Если Элемент.ВыделенныеСтроки.Количество() > 1 Тогда // выделено несколько строк
		Текст = СтрШаблон_(НСтр("ru = 'Удалить выбранные статусы партнеров (выбрано: %1) ?'"), 
					Элемент.ВыделенныеСтроки.Количество());
	Иначе // выделена одна строка
		Текст = НСтр("ru = 'Удалить выбранный статус партнеров?'");
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("СтатусыПартнеровПередУдалениемЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусыПартнеровПередУдалениемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда

		Массив = Новый Массив(); // предварительно запоминаем выделенные строки в промежуточном массиве
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Массив, Элементы.СтатусыПартнеров.ВыделенныеСтроки);

		ОбъектТЧ = Объект.СтатусыПартнеров;	
		Для Каждого ИдСтроки Из Массив Цикл
			ОбъектТЧ.Удалить(ОбъектТЧ.Индекс(ОбъектТЧ.НайтиПоИдентификатору(ИдСтроки)));
		КонецЦикла;
		
		УстановитьМодифицированостьФормы(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСохранитьВсе(Команда)

	УстановитьМодифицированостьФормы(Ложь);
	СохранитьНастройкиСервер();
	Оповестить("АПСтатусыПартнеровИзменение", Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВсеПродолжить(РезультатОтвета, ДополнительныеПараметры) Экспорт
	
	Если РезультатОтвета = КодВозвратаДиалога.Да Тогда
		КомандаСохранитьВсе(Неопределено);
		Закрыть();
	ИначеЕсли РезультатОтвета = КодВозвратаДиалога.Нет Тогда
		УстановитьМодифицированостьФормы(Ложь);
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСправка(Команда)

	ОткрытьФормуОбработки("МодульСправки").ВнешнийВызовОткрытьСправку(ЭтаФорма.ИмяФормы);
	
КонецПроцедуры

#Область ОбработчикиКомандФормы_НавигацияПоФормам

&НаКлиенте
Процедура КомандаПоказатьГлавнуюФорму(Команда)
	
	ОткрытьФормуОбработки("ГлавнаяФорма");
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказатьНастройкиОбмена(Команда)

	ОткрытьФормуОбработки("НастройкиМодуля");

КонецПроцедуры

&НаКлиенте
Функция ОткрытьФормуОбработки(ИмяФормы, стррПараметры = Неопределено, Уникальность = Неопределено, Оповещение = Неопределено)
	
	Если стррПараметры = Неопределено Тогда
		стррПараметры = Новый Структура;
	КонецЕсли; 
	стррПараметры.Вставить("ВХОбщиеПараметры", СтррКонтекст.ВХОбщиеПараметры);
	Возврат ОткрытьФорму(СтррКонтекст.ПутьКФорме + ИмяФормы, стррПараметры, ЭтаФорма, Уникальность,,, Оповещение);
	
КонецФункции

// ОбработчикиКомандФормы_НавигацияПоФормам
#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВосстановитьНастройкиСервер()

	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекОбъект.ВосстановитьЗначенияНастроекОбработки(НастройкиФормы());
	ЗначениеВРеквизитФормы(ТекОбъект, "Объект");

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиСервер()

	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекОбъект.СохранитьЗначенияНастроекОбработки(НастройкиФормы());

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НастройкиФормы()

	Возврат "СтатусыПартнеров";

КонецФункции

&НаКлиенте
Процедура УстановитьМодифицированостьФормы(Режим)
	
	ЭтаФорма.Модифицированность = Режим;
	Элементы.СохранитьВсе.ЦветТекста = СтррКонтекст.Цвета[?(Режим, "ТекстВнимание", "Авто")];
	
КонецПроцедуры

#КонецОбласти