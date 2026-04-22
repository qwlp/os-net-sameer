import {Layout, Rect, Txt, makeScene2D} from '@motion-canvas/2d';
import {all, beginSlide, createRef, createRefArray, waitFor} from '@motion-canvas/core';
import {createSlideFrame} from './helpers';
import {colors, fonts} from '../styles';

const subDigits: Record<string, string> = {
  '0': '₀',
  '1': '₁',
  '2': '₂',
  '3': '₃',
  '4': '₄',
  '5': '₅',
  '6': '₆',
  '7': '₇',
  '8': '₈',
  '9': '₉',
};

const toSub = (value: string | number) =>
  String(value)
    .split('')
    .map(char => subDigits[char] ?? char)
    .join('');

const b = (value: string | number, base: string | number) => `${value}${toSub(base)}`;

const trimTo = (value: string, max: number) => (value.length > max ? `${value.slice(0, max - 1)}…` : value);

type DivisionStep = {
  n: number;
  q: number;
  r: number;
};

type Exercise = {
  section: string;
  prompt: string;
  countingBase?: number;
  lines?: string[];
  decimalPrep?: string;
  tables?: {
    targetBase: number;
    sourceValue: number;
    result: string;
    steps: DivisionStep[];
  }[];
};

const toBase = (n: number, base: number): string => {
  const digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  if (n === 0) return '0';
  let current = n;
  let out = '';
  while (current > 0) {
    out = digits[current % base] + out;
    current = Math.floor(current / base);
  }
  return out;
};

const divisionSteps = (n: number, base: number): DivisionStep[] => {
  const out: DivisionStep[] = [];
  let current = n;
  while (current > 0) {
    const q = Math.floor(current / base);
    const r = current % base;
    out.push({n: current, q, r});
    current = q;
  }
  return out;
};

const digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const fromDecimalToBase = (n: number, base: number) => {
  if (n === 0) return '0';
  let current = n;
  let out = '';
  while (current > 0) {
    out = digits[current % base] + out;
    current = Math.floor(current / base);
  }
  return out;
};

const exercises: Exercise[] = [
  {
    section: 'COUNTING',
    prompt: `a) Count from 1 to ${b(20, 10)} in base 8`,
    countingBase: 8,
  },
  {
    section: 'COUNTING',
    prompt: `b) Count from 1 to ${b(20, 10)} in base 5`,
    countingBase: 5,
  },
  {
    section: 'COUNTING',
    prompt: `c) Count from 1 to ${b(20, 10)} in base 3`,
    countingBase: 3,
  },
  {
    section: 'CONVERTING INTEGERS BETWEEN BASES',
    prompt: 'a) Octal(67) to base 7 and base 6',
    decimalPrep: `${b(67, 8)} = 6 x 8^1 + 7 x 8^0 = ${b(55, 10)}`,
    tables: [
      {targetBase: 7, sourceValue: 55, result: b(106, 7), steps: divisionSteps(55, 7)},
      {targetBase: 6, sourceValue: 55, result: b(131, 6), steps: divisionSteps(55, 6)},
    ],
  },
  {
    section: 'CONVERTING INTEGERS BETWEEN BASES',
    prompt: `b) ${b(91, 10)} to base 7 and base 6`,
    tables: [
      {targetBase: 7, sourceValue: 91, result: b(160, 7), steps: divisionSteps(91, 7)},
      {targetBase: 6, sourceValue: 91, result: b(231, 6), steps: divisionSteps(91, 6)},
    ],
  },
  {
    section: 'CONVERTING INTEGERS BETWEEN BASES',
    prompt: 'c) Hexadecimal(75) to base 7 and base 6',
    decimalPrep: `${b('75', 16)} = ${b(117, 10)}`,
    tables: [
      {targetBase: 7, sourceValue: 117, result: b(225, 7), steps: divisionSteps(117, 7)},
      {targetBase: 6, sourceValue: 117, result: b(313, 6), steps: divisionSteps(117, 6)},
    ],
  },
  {
    section: 'CONVERTING INTEGERS BETWEEN BASES',
    prompt: 'd) Binary(11001) to base 7 and base 6',
    decimalPrep: `${b('11001', 2)} = ${b(25, 10)}`,
    tables: [
      {targetBase: 7, sourceValue: 25, result: b(34, 7), steps: divisionSteps(25, 7)},
      {targetBase: 6, sourceValue: 25, result: b(41, 6), steps: divisionSteps(25, 6)},
    ],
  },
  {
    section: 'TO HEXADECIMAL AND BINARY',
    prompt: `a) Convert ${b(24, 10)}`,
    tables: [
      {targetBase: 16, sourceValue: 24, result: b(18, 16), steps: divisionSteps(24, 16)},
      {targetBase: 2, sourceValue: 24, result: b(11000, 2), steps: divisionSteps(24, 2)},
    ],
  },
  {
    section: 'TO HEXADECIMAL AND BINARY',
    prompt: `b) Convert ${b(6550, 10)}`,
    tables: [
      {targetBase: 16, sourceValue: 6550, result: b('1996', 16), steps: divisionSteps(6550, 16)},
      {targetBase: 2, sourceValue: 6550, result: b('1100110010110', 2), steps: divisionSteps(6550, 2)},
    ],
  },
  {
    section: 'TO HEXADECIMAL AND BINARY',
    prompt: `c) Convert ${b(454, 10)}`,
    tables: [
      {targetBase: 16, sourceValue: 454, result: b('1C6', 16), steps: divisionSteps(454, 16)},
      {targetBase: 2, sourceValue: 454, result: b('111000110', 2), steps: divisionSteps(454, 2)},
    ],
  },
  {
    section: 'TO HEXADECIMAL AND BINARY',
    prompt: `d) Convert ${b(27, 8)}`,
    decimalPrep: `${b(27, 8)} = ${b(23, 10)}`,
    tables: [
      {targetBase: 16, sourceValue: 23, result: b(17, 16), steps: divisionSteps(23, 16)},
      {targetBase: 2, sourceValue: 23, result: b('10111', 2), steps: divisionSteps(23, 2)},
    ],
  },
  {
    section: 'TO HEXADECIMAL AND BINARY',
    prompt: `e) Convert ${b(6325, 8)}`,
    decimalPrep: `${b(6325, 8)} = ${b(3285, 10)}`,
    tables: [
      {targetBase: 16, sourceValue: 3285, result: b('CD5', 16), steps: divisionSteps(3285, 16)},
      {targetBase: 2, sourceValue: 3285, result: b('110011010101', 2), steps: divisionSteps(3285, 2)},
    ],
  },
  {
    section: 'BINARY TO DECIMAL AND HEXADECIMAL',
    prompt: `a) Convert ${b(1101, 2)}`,
    lines: [`${b(1101, 2)} = ${b(13, 10)}`],
    tables: [{targetBase: 16, sourceValue: 13, result: b('D', 16), steps: divisionSteps(13, 16)}],
  },
  {
    section: 'BINARY TO DECIMAL AND HEXADECIMAL',
    prompt: `b) Convert ${b(1000110, 2)}`,
    lines: [`${b(1000110, 2)} = ${b(70, 10)}`],
    tables: [{targetBase: 16, sourceValue: 70, result: b(46, 16), steps: divisionSteps(70, 16)}],
  },
  {
    section: 'BINARY TO DECIMAL AND HEXADECIMAL',
    prompt: `c) Convert ${b(111111, 2)}`,
    lines: [`${b(111111, 2)} = ${b(63, 10)}`],
    tables: [{targetBase: 16, sourceValue: 63, result: b('3F', 16), steps: divisionSteps(63, 16)}],
  },
];

export default makeScene2D(function* (view) {
  const frame = createSlideFrame(
    view,
    '',
    '',
    false,
  );

  const card = createRef<Rect>();
  const section = createRef<Txt>();
  const prompt = createRef<Txt>();
  const prep = createRef<Txt>();
  const lines = createRefArray<Txt>();

  const tableLeftTitle = createRef<Txt>();
  const tableLeftRows = createRefArray<Txt>();
  const tableLeftResult = createRef<Txt>();
  const tableLeftBox = createRef<Rect>();

  const tableRightTitle = createRef<Txt>();
  const tableRightRows = createRefArray<Txt>();
  const tableRightResult = createRef<Txt>();
  const tableRightBox = createRef<Rect>();

  const countingBox = createRef<Rect>();
  const countingRule = createRef<Txt>();
  const countingNow = createRef<Txt>();
  const countingLine1 = createRef<Txt>();
  const countingLine2 = createRef<Txt>();

  const renderTable = (
    titleRef: () => Txt,
    rowRefs: Txt[],
    resultRef: () => Txt,
    tableData: Exercise['tables'][number] | undefined,
  ) => {
    if (!tableData) {
      titleRef().text('');
      resultRef().text('');
      titleRef().opacity(0);
      resultRef().opacity(0);
      for (let i = 0; i < rowRefs.length; i++) {
        rowRefs[i].text('');
        rowRefs[i].opacity(0);
      }
      return;
    }

    titleRef().text(`Base ${tableData.targetBase} table`);
    resultRef().text(`Result: ${b(fromDecimalToBase(tableData.sourceValue, tableData.targetBase), tableData.targetBase)}`);
    titleRef().opacity(0);
    resultRef().opacity(0);

    for (let i = 0; i < rowRefs.length; i++) {
      const step = tableData.steps[i];
      rowRefs[i].text(step ? `${step.n} / ${tableData.targetBase} = ${step.q}   remainder ${step.r}` : '');
      rowRefs[i].opacity(0);
    }
  };

  frame.panel().add(
    <Rect
      ref={card}
      width={1600}
      fill={'#000000'}
      radius={0}
      stroke={colors.line}
      lineWidth={0}
      padding={24}
      layout
      direction={'column'}
      gap={16}
      marginTop={12}
    >
      <Txt ref={section} text={''} fontFamily={fonts.primary} fill={colors.text} fontSize={30} opacity={0} />
      <Txt ref={prompt} text={''} fontFamily={fonts.primary} fill={colors.text} fontSize={38} opacity={0} />
      <Txt ref={prep} text={''} fontFamily={fonts.mono} fill={colors.softText} fontSize={30} opacity={0} />
      {Array.from({length: 2}).map(() => (
        <Txt ref={lines} text={''} fontFamily={fonts.mono} fill={colors.softText} fontSize={30} opacity={0} />
      ))}

      <Rect
        ref={countingBox}
        width={1560}
        fill={'#000000'}
        radius={0}
        stroke={colors.line}
        lineWidth={0}
        padding={14}
        layout
        direction={'column'}
        gap={8}
        opacity={0}
      >
        <Txt ref={countingRule} text={''} fontFamily={fonts.primary} fill={colors.text} fontSize={28} opacity={0} />
        <Txt ref={countingNow} text={''} fontFamily={fonts.mono} fill={colors.text} fontSize={30} opacity={0} />
        <Txt ref={countingLine1} text={''} fontFamily={fonts.mono} fill={colors.softText} fontSize={28} opacity={0} />
        <Txt ref={countingLine2} text={''} fontFamily={fonts.mono} fill={colors.softText} fontSize={28} opacity={0} />
      </Rect>

      <Layout direction={'row'} gap={20}>
        <Rect ref={tableLeftBox} width={770} fill={'#000000'} radius={0} stroke={colors.line} lineWidth={0} padding={14} layout direction={'column'} gap={8}>
          <Txt ref={tableLeftTitle} text={''} fontFamily={fonts.primary} fill={colors.text} fontSize={28} opacity={0} />
          {Array.from({length: 16}).map(() => (
            <Txt ref={tableLeftRows} text={''} fontFamily={fonts.mono} fill={colors.softText} fontSize={25} opacity={0} />
          ))}
          <Txt ref={tableLeftResult} text={''} fontFamily={fonts.primary} fill={colors.text} fontSize={26} opacity={0} />
        </Rect>

        <Rect ref={tableRightBox} width={770} fill={'#000000'} radius={0} stroke={colors.line} lineWidth={0} padding={14} layout direction={'column'} gap={8}>
          <Txt ref={tableRightTitle} text={''} fontFamily={fonts.primary} fill={colors.text} fontSize={28} opacity={0} />
          {Array.from({length: 16}).map(() => (
            <Txt ref={tableRightRows} text={''} fontFamily={fonts.mono} fill={colors.softText} fontSize={25} opacity={0} />
          ))}
          <Txt ref={tableRightResult} text={''} fontFamily={fonts.primary} fill={colors.text} fontSize={26} opacity={0} />
        </Rect>
      </Layout>
    </Rect>,
  );

  for (let i = 0; i < exercises.length; i++) {
    const exercise = exercises[i];
    const isCounting = exercise.countingBase !== undefined;

    section().opacity(0);
    prompt().opacity(0);
    prep().opacity(0);
    for (let j = 0; j < lines.length; j++) {
      lines[j].text('');
      lines[j].opacity(0);
    }

    countingRule().text('');
    countingNow().text('');
    countingLine1().text('');
    countingLine2().text('');
    countingRule().opacity(0);
    countingNow().opacity(0);
    countingLine1().opacity(0);
    countingLine2().opacity(0);

    tableLeftBox().opacity(isCounting ? 0 : 1);
    tableRightBox().opacity(isCounting ? 0 : 1);
    countingBox().opacity(isCounting ? 1 : 0);

    renderTable(tableLeftTitle, tableLeftRows, tableLeftResult, exercise.tables?.[0]);
    renderTable(tableRightTitle, tableRightRows, tableRightResult, exercise.tables?.[1]);

    yield* beginSlide(`exercise-${i + 1}-prompt`);
    section().text(exercise.section);
    prompt().text(trimTo(exercise.prompt, 62));
    yield* all(section().opacity(1, 0.2), prompt().opacity(1, 0.2));

    if (exercise.decimalPrep) {
      yield* beginSlide(`exercise-${i + 1}-prep`);
      prep().text(trimTo(exercise.decimalPrep, 86));
      yield* prep().opacity(1, 0.25);
    }

    if (exercise.lines) {
      for (let j = 0; j < exercise.lines.length; j++) {
        yield* beginSlide(`exercise-${i + 1}-line-${j + 1}`);
        lines[j].text(trimTo(exercise.lines[j], 92));
        yield* lines[j].opacity(1, 0.25);
      }
    }

    if (isCounting) {
      const base = exercise.countingBase as number;
      const terms = Array.from({length: 20}, (_, n) => b(toBase(n + 1, base), base));
      yield* beginSlide(`exercise-${i + 1}-counting-rule`);
      countingRule().text(`Counting in base ${base}: carry when a digit reaches ${base - 1}.`);
      yield* all(countingRule().opacity(1, 0.2), countingNow().opacity(1, 0.2));

      const chunkSize = 5;
      for (let end = chunkSize; end <= 20; end += chunkSize) {
        yield* beginSlide(`exercise-${i + 1}-counting-up-to-${end}`);
        const shown = terms.slice(0, end);
        countingNow().text(`${b(end, 10)} -> ${terms[end - 1]}`);
        countingLine1().text(trimTo(shown.slice(0, 10).join(', '), 90));
        countingLine2().text(trimTo(shown.slice(10).join(', '), 90));
        yield* all(countingLine1().opacity(1, 0.2), countingLine2().opacity(1, 0.2));
      }
    }

    if (!isCounting && exercise.tables?.[0]) {
      yield* beginSlide(`exercise-${i + 1}-left-table-title`);
      yield* tableLeftTitle().opacity(1, 0.2);
      const leftRowsToShow = Math.min(exercise.tables[0].steps.length, tableLeftRows.length);
      for (let j = 0; j < leftRowsToShow; j++) {
        yield* beginSlide(`exercise-${i + 1}-left-table-row-${j + 1}`);
        yield* tableLeftRows[j].opacity(1, 0.2);
      }
      yield* beginSlide(`exercise-${i + 1}-left-table-result`);
      yield* tableLeftResult().opacity(1, 0.2);
      yield* waitFor(0.8);
    }

    if (!isCounting && exercise.tables?.[1]) {
      yield* beginSlide(`exercise-${i + 1}-right-table-title`);
      yield* tableRightTitle().opacity(1, 0.2);
      const rightRowsToShow = Math.min(exercise.tables[1].steps.length, tableRightRows.length);
      for (let j = 0; j < rightRowsToShow; j++) {
        yield* beginSlide(`exercise-${i + 1}-right-table-row-${j + 1}`);
        yield* tableRightRows[j].opacity(1, 0.2);
      }
      yield* beginSlide(`exercise-${i + 1}-right-table-result`);
      yield* tableRightResult().opacity(1, 0.2);
      yield* waitFor(0.8);
    }
  }

  yield* beginSlide('lab1-full-end');
});
