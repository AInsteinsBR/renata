# ADR-NNN — Frontend baseado no starter `{{STARTER_NAME}}`

> ⚠️ **Este é um template gerado automaticamente pelo `init.sh --starter`.**
> Se você está retrofitando manualmente, pode usar este template como base — ajuste `{{...}}` para refletir seu starter real.

- **Status:** accepted
- **Data:** {{TODAY}}
- **Autor:** {{AUTHOR}}
- **Supersedes:** —
- **Superseded by:** —

---

## Contexto

Este projeto utiliza o starter kit **{{STARTER_NAME}}** ({{STARTER_URL}}) como base do frontend. O starter já define:

- Stack (framework, linguagem, build tool)
- Componentes base
- Tema visual (paleta, tipografia, espaçamentos)
- Convenções de pasta e arquivo
- Boilerplate de configuração (lint, formatter, testes)

Adotar o starter significa que **o frontend deste projeto herda todas as decisões estruturais do starter** sem reabrir cada uma como ADR própria.

## Decisão

1. **O frontend deste projeto é construído a partir do clone do starter `{{STARTER_NAME}}`** em `frontend/`.
2. **Decisões estruturais do starter são herdadas automaticamente** — não precisam ser refletidas em ADRs próprias deste projeto, exceto se forem **mudadas** localmente.
3. **Mudanças locais que divergem do starter exigem nova ADR** (com `Supersedes` apontando para esta ADR, ou complementar a ela).
4. **Atualização do starter:** quando o repo do starter for atualizado, é responsabilidade do time deste projeto decidir se sincroniza (e como).

## Alternativas consideradas

| Opção | Por que NÃO foi escolhida |
|---|---|
| **Não usar starter (escrever frontend do zero)** | Repete trabalho. Cada projeto teria que reabrir decisões já tomadas (Next vs Remix, shadcn vs Material, etc). Padrão se dissolve. |
| **Outro starter externo (Next.js boilerplate genérico, etc)** | Não respeita o padrão visual/técnico já estabelecido pelo time. |
| **Copiar manualmente trechos do starter sem clonar** | Perde o link com o repo origem — atualizações futuras do starter não chegam neste projeto. |

## Justificativa amarrada

- **Restrição @padrão do time:** time já estabeleceu padrão visual e técnico no starter `{{STARTER_NAME}}`. Repetir essas decisões em cada projeto seria refazer trabalho.
- **Restrição @velocidade:** projetos novos precisam ir de zero ao primeiro deploy em dias, não em semanas. Starter remove fricção inicial.
- **Restrição @consistência:** múltiplos projetos com mesmo padrão facilitam manutenção, onboarding e mobilidade de devs entre projetos.

## Trade-offs aceitos

- **Acoplamento ao starter.** Se o starter tem bug ou decisão ruim, todos os projetos herdam. Aceito porque starter é controlado pelo time.
- **Atualizações do starter** podem trazer breaking changes. Aceito — política de update é manual e ponderada.
- **Liberdade de divergir reduzida.** Aceito — se um projeto precisa divergir significativamente, é sinal de que o starter pode estar errado ou que este projeto não é o caso de uso do starter.

## Gatilho de revisão

Revisitar esta decisão se:

1. **Starter está claramente errado pra este projeto** (>30% do código sendo reescrito desviando do padrão).
2. **Time decide migrar para outro stack** (novo starter substitui este).
3. **Custo de manter o starter atualizado** ficar maior que o benefício de reuso.

## Enforcement

- **Repo origem:** `frontend/` deste projeto é clone do starter. `git remote -v` no frontend mostra o starter como origem alternativa.
- **Convenções herdadas:** linters, formatters, scripts do starter são executados em CI deste projeto.
- **ADR de divergência:** PR que altera estrutura do starter dentro deste projeto exige nova ADR (review checklist).
- **Documentação local:** este projeto não duplica documentação do starter — refere-se a ele (`{{STARTER_URL}}/README.md`).

## Como usar este starter neste projeto

```bash
# Já feito pelo init.sh --starter, mas se precisar refazer manualmente:
cd /caminho/do/projeto
git clone {{STARTER_URL}} frontend
cd frontend && rm -rf .git   # desliga o repo origem do starter
# Para atualizar com upstream do starter no futuro:
git remote add starter {{STARTER_URL}}
git fetch starter
# Mergir/cherry-pick conforme necessidade.
```

## Referências

- Starter: {{STARTER_URL}}
- Design system documentado em: `frontend/DESIGN-SYSTEM.md` (ou conforme convenção do starter)
- ADRs deste projeto que dependem desta: nenhuma ainda (atualizar conforme aparecem)
