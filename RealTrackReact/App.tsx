import { StatusBar } from 'expo-status-bar';
import React, { useState } from 'react';
import {
  FlatList,
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Switch,
  Text,
  TextInput,
  View,
  Pressable
} from 'react-native';
import { createPersonClient } from './src/lib/api';
import { PersonCard } from './src/components/PersonCard';
import type { Person } from './src/types/person';

const searchModes = [
  { key: 'email', label: 'Email Address' },
  { key: 'lastName', label: 'Last Name' },
  { key: 'id', label: 'Person ID' }
] as const;

type SearchMode = (typeof searchModes)[number]['key'];

export default function App() {
  const [mode, setMode] = useState<SearchMode>('email');
  const [email, setEmail] = useState('');
  const [lastName, setLastName] = useState('');
  const [prefix, setPrefix] = useState(true);
  const [personId, setPersonId] = useState('');
  const [people, setPeople] = useState<Person[]>([]);
  const [status, setStatus] = useState<'idle' | 'loading' | 'error' | 'success'>('idle');
  const [error, setError] = useState<string | null>(null);
  const client = createPersonClient();

  const runSearch = async () => {
    setStatus('loading');
    setError(null);
    try {
      let results: Person[] = [];
      if (mode === 'email') {
        if (!email.trim()) {
          throw new Error('Enter an email address.');
        }
        const match = await client.getByEmail(email.trim());
        results = match ? [match] : [];
      } else if (mode === 'lastName') {
        if (!lastName.trim()) {
          throw new Error('Enter a last name.');
        }
        results = await client.searchByLastName(lastName.trim(), prefix);
      } else {
        if (!personId.trim()) {
          throw new Error('Enter a person id.');
        }
        const person = await client.getById(personId.trim());
        results = person ? [person] : [];
      }
      setPeople(results);
      setStatus('success');
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to load people.';
      setError(message);
      setPeople([]);
      setStatus('error');
    }
  };

  const renderControls = () => {
    if (mode === 'email') {
      return (
        <TextInput
          style={styles.input}
          placeholder="demo@example.com"
          autoCapitalize="none"
          keyboardType="email-address"
          value={email}
          onChangeText={setEmail}
        />
      );
    }

    if (mode === 'lastName') {
      return (
        <View style={styles.lastNameRow}>
          <TextInput
            style={[styles.input, styles.lastNameInput]}
            placeholder="Doe"
            autoCapitalize="words"
            value={lastName}
            onChangeText={setLastName}
          />
          <View style={styles.switchRow}>
            <Text style={styles.switchLabel}>Prefix</Text>
            <Switch value={prefix} onValueChange={setPrefix} />
          </View>
        </View>
      );
    }

    return (
      <TextInput
        style={styles.input}
        placeholder="PER_01H..."
        autoCapitalize="characters"
        value={personId}
        onChangeText={setPersonId}
      />
    );
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar style="auto" />
      <ScrollView contentContainerStyle={styles.scrollContainer} keyboardShouldPersistTaps="handled">
        <Text style={styles.header}>RealTrack — People Lookup</Text>
        <Text style={styles.subtitle}>
          Search the RealTrack API for people by email, last name (with optional prefix scans), or person id.
        </Text>

        <View style={styles.modeRow}>
          {searchModes.map((option, index) => (
            <Pressable
              key={option.key}
              onPress={() => setMode(option.key)}
              style={[
                styles.modeButton,
                mode === option.key && styles.modeButtonActive,
                index !== searchModes.length - 1 && styles.modeButtonSpacing
              ]}
            >
              <Text style={[styles.modeButtonText, mode === option.key && styles.modeButtonTextActive]}>
                {option.label}
              </Text>
            </Pressable>
          ))}
        </View>

        {renderControls()}

        <Pressable style={styles.searchButton} onPress={runSearch}>
          <Text style={styles.searchButtonText}>Search</Text>
        </Pressable>

        {status === 'loading' && <Text style={styles.statusText}>Looking up people…</Text>}
        {error && status === 'error' && <Text style={[styles.statusText, styles.errorText]}>{error}</Text>}

        <FlatList
          data={people}
          keyExtractor={(item) => item.personId}
          renderItem={({ item }) => <PersonCard person={item} />}
          ListEmptyComponent={() =>
            status === 'success' ? (
              <Text style={styles.emptyState}>No people matched the criteria.</Text>
            ) : null
          }
          scrollEnabled={false}
          contentContainerStyle={styles.listContainer}
        />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0f172a'
  },
  scrollContainer: {
    paddingHorizontal: 20,
    paddingTop: 32,
    paddingBottom: 80
  },
  header: {
    fontSize: 28,
    fontWeight: '700',
    color: '#f8fafc',
    marginBottom: 8
  },
  subtitle: {
    color: '#cbd5f5',
    marginBottom: 24,
    fontSize: 16,
    lineHeight: 22
  },
  modeRow: {
    flexDirection: 'row',
    marginBottom: 16
  },
  modeButton: {
    flex: 1,
    paddingVertical: 10,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#1d4ed8'
  },
  modeButtonActive: {
    backgroundColor: '#1d4ed8'
  },
  modeButtonSpacing: {
    marginRight: 12
  },
  modeButtonText: {
    textAlign: 'center',
    color: '#bfdbfe',
    fontWeight: '600'
  },
  modeButtonTextActive: {
    color: '#f8fafc'
  },
  input: {
    backgroundColor: '#1e293b',
    borderRadius: 8,
    padding: 14,
    color: '#f8fafc',
    borderWidth: 1,
    borderColor: '#334155',
    marginBottom: 16
  },
  lastNameRow: {
    width: '100%'
  },
  lastNameInput: {
    marginBottom: 8
  },
  switchRow: {
    flexDirection: 'row',
    alignItems: 'center'
  },
  switchLabel: {
    color: '#f8fafc',
    marginRight: 8
  },
  searchButton: {
    backgroundColor: '#22c55e',
    paddingVertical: 14,
    borderRadius: 10,
    marginBottom: 12
  },
  searchButtonText: {
    textAlign: 'center',
    fontWeight: '700',
    color: '#022c22'
  },
  statusText: {
    color: '#fef3c7',
    marginBottom: 8
  },
  errorText: {
    color: '#fda4af'
  },
  listContainer: {
    paddingBottom: 32
  },
  emptyState: {
    color: '#94a3b8',
    textAlign: 'center',
    marginTop: 12
  }
});
